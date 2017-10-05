# rubocop:disable Metrics/ModuleLength
require "rails_helper"

# Anaemia Audit
# TODO: list
# - Refactor helpers into an AuditHelper mixin as some duplication here with other audit tests.
# - Remove rubocop disable above
# - Rename bone audit describe block
module Renalware
  RSpec.describe "Anaemia Audit", type: :model do
    include PatientsSpecHelper
    let(:uom) { create(:pathology_measurement_unit) }
    let(:user) { create(:user) }
    let(:audit_view_name) { "reporting_anaemia_audit" }

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

    describe "reporting_aneamia_audit view" do
      describe "columns" do
        it "contains the column names" do
          columns, _values = Reporting::GenerateAuditJson.call(audit_view_name)
          columns = JSON.parse(columns).map(&:symbolize_keys)
          titles = columns.map{ |column| column[:title] }
          expect(titles).to eq(
            %w(
              modality
              patient_count
              avg_hb
              pct_hb_gt_eq_10
              pct_hb_gt_eq_11
              pct_hb_gt_eq_13
              avg_fer
              pct_fer_gt_eq_150
            )
          )
        end
      end

      describe "values" do
        context "when there is no data" do
          it "is an empty array" do
            _columns, values = Reporting::GenerateAuditJson.call(audit_view_name)
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
            hd_patient3 = create_hd_patient
            hd_patient4 = create_hd_patient
            create_pd_patient

            # HB
            hb = create_observation_description("HB")
            create_observation(patient: hd_patient1, description: hb, result: 9)
            create_observation(patient: hd_patient2, description: hb, result: 10)
            create_observation(patient: hd_patient3, description: hb, result: 11)
            create_observation(patient: hd_patient4, description: hb, result: 14)

            # FER
            fer = create_observation_description("FER")
            create_observation(patient: hd_patient1, description: fer, result: 140)
            create_observation(patient: hd_patient2, description: fer, result: 150)
            create_observation(patient: hd_patient3, description: fer, result: 205)

            # TODO: EPO ...

            _columns, values = Reporting::GenerateAuditJson.call(audit_view_name)
            expect(values).to eq(
              [
                [
                  "HD",     # modality
                  4,        # count of hd patients
                  "11.00",  # avg_hb (9 + 10 + 11 + 14) / 4 = 11
                  "75.00",  # pct_hb_gt_eq_10 = all bar 1 = 75%
                  "50.00",  # pct_hb_gt_eq_11 = 2 = 50%
                  "25.00",  # pct_hb_gt_eq_13 = 1 = 25%
                  "165.00", # avg_fer = (140 + 150 + 205) / 3 = 165
                  "66.67"   # pct_fer_gt_eq_150 = 2 of 3 = 66.66
                ],
                [
                  "PD",
                  1,
                  nil,
                  "0.00",
                  "0.00",
                  "0.00",
                  nil,
                  "0.00"
                ]
              ]
            )
          end
        end
      end
    end
  end
end
