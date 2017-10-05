require "rails_helper"

module Renalware
  RSpec.describe Reporting::GenerateAuditJson, type: :model do
    include PatientsSpecHelper
    let(:uom) { create(:pathology_measurement_unit) }
    let(:user) { create(:user) }

    def create_observation_description(code)
      create(:pathology_observation_description, code: code, measurement_unit: uom)
    end

    def create_observation(patient:, description:, result:)
      request = create(:pathology_observation_request, patient: patient)
      create(:pathology_observation,
       request: request,
       description: description,
       result: result
     )
    end

    def create_hd_patient
      create(:pathology_patient, by: user).tap do |patient|
        set_modality(patient: patient,
                     modality_description: create(:hd_modality_description),
                     by: user)
      end
    end

    def create_pd_patient
      create(:pathology_patient, by: user).tap do |patient|
        set_modality(patient: patient,
                     modality_description: create(:pd_modality_description),
                     by: user)
      end
    end

    describe "reporting_bone_audit view" do
      describe "columns" do
        it "contains the column names" do
          columns, _values = Reporting::GenerateAuditJson.call("reporting_bone_audit")
          columns = JSON.parse(columns).map(&:symbolize_keys)
          titles = columns.map{ |column| column[:title] }
          expect(titles).to eq(%w(modality patient_count avg_cca pct_cca_2_1_to_2_4 pct_pth_gt_300
                                  pct_pth_gt_800_pct avg_phos max_phos pct_phos_lt_1_8))
        end
      end

      describe "values" do
        context "when there is no data" do
          it "is an empty array" do
            _columns, values = Reporting::GenerateAuditJson.call("reporting_bone_audit")
            expect(values).to eq([])
          end
        end
        context "when data" do
          it "is correctly aggregates CC PTH and PHOS data" do
            # We will just add path data to 2 HD patients in this example.
            # We just create a PD patient to test that PD patient_count is correct
            # in the view output.
            hd_patient1 = create_hd_patient
            hd_patient2 = create_hd_patient
            create_pd_patient

            # CCA
            cca = create_observation_description("CCA")
            create_observation(patient: hd_patient1, description: cca, result: 2.0)
            create_observation(patient: hd_patient2, description: cca, result: 2.3)

            # PTH
            pth = create_observation_description("PTH")
            create_observation(patient: hd_patient1, description: pth, result: 300.1)
            create_observation(patient: hd_patient2, description: pth, result: 800.1)

            # PHOS
            phos = create_observation_description("PHOS")
            create_observation(patient: hd_patient1, description: phos, result: 2.0)
            create_observation(patient: hd_patient2, description: phos, result: 1.0)

            _columns, values = Reporting::GenerateAuditJson.call("reporting_bone_audit")
            expect(values).to eq(
              [
                ["HD",      # modality
                  2,        # count of hd patients
                  "2.15",   # avg_cca
                  "50.00",  # pct_cca_2_1_to_2_4
                  "100.00", # pct_pth_gt_300
                  "50.00",  # pct_pth_gt_800_pct
                  "1.50",   # avg_phos
                  "2.0",    # max_phos
                  "50.00"], # pct_phos_lt_1_8 = 50%
                ["PD",
                  1,
                  nil,
                  "0.00",
                  "0.00",
                  "0.00",
                  nil,
                  nil,
                  "0.00"]
              ]
            )
          end
        end
      end
    end
  end
end
