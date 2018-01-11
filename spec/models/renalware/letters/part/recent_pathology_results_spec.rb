require "rails_helper"

module Renalware::Letters
  describe Part::RecentPathologyResults do
    subject(:part) { described_class.new(patient, letter, event) }

    let(:user) { create(:user) }
    let(:patient) { create(:patient, by: user) }
    let(:event) { nil }
    let(:letter) { Letter.new }

    it { is_expected.to respond_to(:recent_pathology_results) }

    describe "#recent_pathology_results" do
      context "when we have a current observation set" do
        let(:letter) { instance_double(Letter, pathology_snapshot: pathology_snapshot) }
        # 3 dates we might expect to see when out observations span 3 OBRs
        # (observation requests)
        let(:obr_1_date) { "2017-12-12 00:01:01" } # ie FBC (Full Blood Count)
        let(:obr_2_date) { "2017-12-12 00:12:01" }
        let(:obr_3_date) { "2017-11-11 00:01:01" }
        let(:obr_4_date) { "2017-11-11 00:23:59" }
        let(:obr_5_date) { "2017-10-11 00:23:59" }

        before do
          create(:pathology_observation_description, code: "HGB", name: "HGB")
          create(:pathology_observation_description, code: "PLT", name: "PLT")
          create(:pathology_observation_description, code: "WBC", name: "WBC")
          create(:pathology_observation_description, code: "URE", name: "Urea")
          create(:pathology_observation_description, code: "CRE", name: "Creatinine")
          create(:pathology_observation_description, code: "POT", name: "Potassium")
          create(:pathology_observation_description, code: "NA", name: "Sodium")
          create(:pathology_observation_description, code: "BIC", name: "Bicarbonate")
          create(:pathology_observation_description, code: "CCA", name: "Corrected Calc")
          create(:pathology_observation_description, code: "PHOS", name: "Phosphate")
          create(:pathology_observation_description, code: "ALB", name: "Albumin")
        end

        # Randomise the order of entries in the observation set to
        # mimic how it looks (a trigger updates or inserts at the end new OBXsa as they
        # arrive via HL7).
        # This is not the complete set of letter codes in
        # Letters::RelevantObservationDescription.codes, but enough to determine we are
        # outputting the result correctly
        let(:pathology_snapshot) do
          {
            HGB: { result: 122, observed_at: obr_1_date },
            PLT: { result: 329, observed_at: obr_1_date },
            WBC: { result: 15.32, observed_at: obr_1_date },
            URE: { result: 24.8, observed_at: obr_2_date },
            CRE: { result: 782, observed_at: obr_3_date },
            POT: { result: 6.0, observed_at: obr_3_date },
            NA: { result: 134, observed_at: obr_3_date },
            BIC: { result: 18, observed_at: obr_4_date },
            CCA: { result: 2.29, observed_at: obr_5_date },
            PHOS: { result: 2.52, observed_at: obr_5_date },
            ALB: { result: 41, observed_at: obr_5_date }
          }
        end

        it "returns a string of observations grouped by OBR date "\
           "and ordered correctly" do
          expected_results =
            "12-Dec-2017: HGB 122, Plt 329, WBC 15.32; "\
            "12-Dec-2017: Urea 24.8; "\
            "11-Nov-2017: Creat 782 (eGFR-MDRD 6), K 6.0, Na 134; "\
            "11-Nov-2017: Bicarb 18; "\
            "11-Oct-2017: Correct Ca 2.29, Phos 2.52, Alb 41;"

          expect(part.recent_pathology_results).to eq(expected_results)
        end
      end
    end
  end
end
