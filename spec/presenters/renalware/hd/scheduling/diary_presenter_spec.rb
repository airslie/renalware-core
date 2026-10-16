module Renalware::HD::Scheduling
  describe DiaryPresenter do
    subject(:presenter) { described_class.new(user, weekly_diary) }

    let(:user) { create(:user) }
    let(:am) { create(:hd_diurnal_period_code, :am) }
    let(:unit) { create(:hospital_unit) }
    let(:master_diary) { create(:hd_master_diary, hospital_unit: unit) }
    let(:weekly_diary) do
      create(:hd_weekly_diary, master_diary:, hospital_unit: unit, year: 2018, week_number: 33)
    end
    let!(:station) { create(:hd_station, hospital_unit: unit, name: "S1") }

    def persisted_flags(slots) = slots.map { |slot| slot.id.present? }

    def collect_periods
      periods = []
      presenter.each_diurnal_period { |period| periods << period.code }
      periods
    end

    def collect_stations
      stations = []
      presenter.each_station { |st, index| stations << [st.name, index] }
      stations
    end

    def collect_slots
      slots = []
      presenter.each_day(am, station) { |slot| slots << slot }
      slots
    end

    describe "#day_names" do
      it "excludes Sunday by default" do
        expect(presenter.day_names).to eq(%i(monday tuesday wednesday thursday friday saturday))
      end

      it "includes Sunday when configured" do
        allow(Renalware.config).to receive(:include_sunday_on_hd_diaries).and_return(true)

        expect(presenter.day_names.last).to eq(:sunday)
        expect(presenter.day_names.length).to eq(7)
      end
    end

    describe "#stations" do
      it "returns only the unit's stations, ordered by position" do
        second = create(:hd_station, hospital_unit: unit, name: "S2")
        create(:hd_station, name: "Other unit")
        station.update!(position: second.position + 1, by: user)

        expect(presenter.stations.map(&:name)).to eq(%w(S2 S1))
      end
    end

    describe "#each_station" do
      it "yields each station with a 1-based index" do
        expect(collect_stations).to eq([["S1", 1]])
      end
    end

    describe "#each_diurnal_period" do
      it "yields every diurnal period code" do
        am
        expect(collect_periods).to include("am")
      end
    end

    describe "#each_day" do
      it "yields an empty NullSlot for each day when nothing is scheduled" do
        slots = collect_slots

        expect(slots.length).to eq(6)
        expect(slots.map(&:day_of_week)).to eq((1..6).to_a)
        expect(persisted_flags(slots)).to eq([false] * 6)
        expect(slots.first.cell_id).to eq("#{am.id}-#{station.id}-1")
      end

      it "yields a weekly slot in preference to a master slot on the same day" do
        weekly_slot = create_slot(weekly_diary, 1)
        create_slot(master_diary, 1, patient: create(:hd_patient), created_at: 1.year.ago)

        first = collect_slots.first

        expect(first.id).to eq(weekly_slot.id)
        expect(first).not_to be_master
      end

      it "falls back to a master slot created before the week being viewed" do
        master_slot = create_slot(master_diary, 2, created_at: Time.zone.local(2018, 1, 1))

        second = collect_slots.second

        expect(second.id).to eq(master_slot.id)
        expect(second).to be_master
      end

      it "ignores master slots created after the week being viewed" do
        create_slot(master_diary, 2, created_at: Time.zone.local(2019, 1, 1))

        expect(collect_slots.second).not_to be_a(DiarySlot)
      end

      def create_slot(diary, day_of_week, **attrs)
        create(
          :hd_diary_slot,
          diary:,
          station:,
          diurnal_period_code: am,
          day_of_week:,
          by: user,
          **attrs
        )
      end
    end
  end
end
