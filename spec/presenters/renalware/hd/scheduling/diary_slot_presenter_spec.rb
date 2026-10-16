module Renalware::HD::Scheduling
  describe DiarySlotPresenter do
    subject(:presenter) { described_class.new(slot) }

    let(:unit) { create(:hd_hospital_unit, unit_code: "ABC") }
    let(:station) { create(:hd_station, hospital_unit: unit) }
    let(:am) { create(:hd_diurnal_period_code, :am) }
    let(:diary) { create(:hd_weekly_diary, hospital_unit: unit) }
    let(:slot) do
      build(:hd_diary_slot, diary:, station:, diurnal_period_code: am, day_of_week: 2)
    end

    describe "#master?" do
      it "delegates to the diary" do
        expect(presenter).not_to be_master
      end
    end

    describe "#patient_search_options" do
      let(:options) { presenter.patient_search_options("/hd/diaries/1/slots/new?a=b") }

      def texts(options) = options.transform_values { |opt| opt[:text] }

      it "offers the four patient search scopes" do
        expect(options.keys).to eq(
          %i(dialysing_on_day_and_period dialysing_on_day dialysing_at_unit dialysing_at_hospital)
        )
      end

      it "labels each scope for the day, period and unit" do
        expect(texts(options)).to eq(
          dialysing_on_day_and_period: "Dialysing Tuesday AM",
          dialysing_on_day: "Dialysing on Tuesday",
          dialysing_at_unit: "All ABC HD patients",
          dialysing_at_hospital: "All HD patients"
        )
      end

      it "adds the patient_search_scope to the existing query string for each turbo frame" do
        frame_url = options[:dialysing_on_day][:meta][:data][:frame_url]

        expect(frame_url).to eq(
          "/hd/diaries/1/slots/new?a=b&patient_search_scope=dialysing_on_day"
        )
      end

      it "uses ajax lookups for the unit and hospital wide scopes" do
        expect(options[:dialysing_at_unit][:options_url]).to include("REPLACEME")
        expect(options[:dialysing_at_hospital][:options_url]).to include("REPLACEME")
      end
    end

    describe "#patients_preferring_to_dialyse_today_in_this_period" do
      it "returns [text, id] pairs for patients scheduled on that day and period" do
        patient = create(:hd_patient)
        allow(Renalware::HD::PatientsDialysingByDayAndPeriodQuery)
          .to receive(:new).with(unit.id, 2, "am")
          .and_return(instance_double(Renalware::HD::PatientsDialysingByDayAndPeriodQuery,
                                      call: Renalware::HD::Patient.where(id: patient.id)))

        result = presenter.patients_preferring_to_dialyse_today_in_this_period

        expect(result.map(&:last)).to eq([patient.id])
        expect(result.first.first).to include(patient.family_name.upcase)
      end
    end
  end
end
