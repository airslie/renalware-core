module Renalware::HD::Scheduling
  describe DiarySlot do
    let(:user) { create(:user) }
    let(:am) { create(:hd_diurnal_period_code, :am) }
    let(:pm) { create(:hd_diurnal_period_code, :pm) }
    let(:station) { create(:hd_station) }
    let(:master_diary) { create(:hd_master_diary, hospital_unit: station.hospital_unit) }
    let(:weekly_diary) do
      create(:hd_weekly_diary, master_diary:, hospital_unit: station.hospital_unit)
    end

    def build_slot(**attrs)
      build(
        :hd_diary_slot,
        diary: weekly_diary,
        station:,
        diurnal_period_code: am,
        day_of_week: 1,
        **attrs
      )
    end

    describe "#description" do
      it "describes a master diary slot as recurring" do
        slot = build_slot(diary: master_diary, day_of_week: 3, diurnal_period_code: pm)

        expect(slot.description).to eq("Recurring every Wednesday PM")
      end

      it "describes a weekly diary slot as this week only" do
        slot = build_slot(day_of_week: 5)

        expect(slot.description).to eq("This week only on Friday AM")
      end
    end

    describe "#day_of_week_name" do
      it "maps 1 to Monday and 7 to Sunday" do
        expect(build_slot(day_of_week: 1).day_of_week_name).to eq(:Monday)
        expect(build_slot(day_of_week: 7).day_of_week_name).to eq(:Sunday)
      end
    end

    describe "#cell_id" do
      it "combines the period, station and day so the slot can be located in the diary table" do
        slot = build_slot(day_of_week: 2)

        expect(slot.cell_id).to eq("#{am.id}-#{station.id}-2")
      end
    end

    describe "#on_master_diary?" do
      it "is true for a slot on the master diary" do
        expect(build_slot(diary: master_diary).on_master_diary?).to be(true)
      end

      it "is false for a slot on a weekly diary" do
        expect(build_slot.on_master_diary?).to be(false)
      end
    end

    describe "scopes" do
      let!(:unarchived_weekly) { create_slot(diary: weekly_diary, day_of_week: 1) }
      let!(:archived_weekly) { create_slot(diary: weekly_diary, day_of_week: 2, archived: true) }

      before { create_slot(diary: master_diary, day_of_week: 3) }

      def create_slot(diary:, day_of_week:, archived: false)
        create(
          :hd_diary_slot,
          diary:,
          station:,
          diurnal_period_code: am,
          day_of_week:,
          archived:,
          by: user
        )
      end

      it ".weekly excludes master diary slots" do
        expect(described_class.weekly).to contain_exactly(unarchived_weekly, archived_weekly)
      end

      it ".archived returns only archived weekly slots" do
        expect(described_class.archived).to contain_exactly(archived_weekly)
      end

      it ".unarchived returns only unarchived weekly slots" do
        expect(described_class.unarchived).to contain_exactly(unarchived_weekly)
      end
    end

    describe "uniqueness validations" do
      before do
        create(
          :hd_diary_slot,
          diary: weekly_diary,
          station:,
          diurnal_period_code: am,
          day_of_week: 1,
          by: user
        )
      end

      it "prevents the same patient being in two stations in the same period and day" do
        existing = described_class.last
        other_station = create(:hd_station, hospital_unit: station.hospital_unit, name: "B")
        slot = build_slot(patient: existing.patient, station: other_station)

        expect(slot).not_to be_valid
        expect(slot.errors).to include(:patient_id)
      end

      it "prevents two patients being given the same station, period and day" do
        slot = build_slot

        expect(slot).not_to be_valid
        expect(slot.errors).to include(:diurnal_period_code_id)
      end

      it "allows the same patient in a different period on the same day" do
        existing = described_class.last

        expect(build_slot(patient: existing.patient, diurnal_period_code: pm)).to be_valid
      end

      it "allows the same station and period on a different day" do
        expect(build_slot(day_of_week: 2)).to be_valid
      end
    end
  end
end
