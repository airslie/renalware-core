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
    let(:request_description) { create(:pathology_request_description, lab: lab) }
    let(:lab) { create(:pathology_lab) }

    def create_observation_description(code)
      create(:pathology_observation_description, code: code, measurement_unit: uom)
    end

    def create_observation(patient:, description:, result:)
      request = create(
        :pathology_observation_request,
        patient: patient,
        description: request_description
      )
      create(
        :pathology_observation,
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
        it "contains the correct column names" do
          columns, _values = Reporting::GenerateAuditJson.call(audit_view_name)
          columns = JSON.parse(columns).map(&:symbolize_keys)
          titles = columns.map{ |column| column[:title] }
          expect(titles).to eq(
            %w(
              modality
              patient_count
              avg_hgb
              pct_hgb_gt_eq_10
              pct_hgb_gt_eq_11
              pct_hgb_gt_eq_13
              avg_fer
              pct_fer_gt_eq_150
              no_on_epo
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
          it "is correctly generates values" do
            # We will just add path data to 2 HD patients in this example.
            # We just create a PD patient to test that PD patient_count is correct
            # in the view output.
            hd_patients = Array.new(4) { create_hd_patient }
            create_pd_patient

            # HGB
            hgb = create_observation_description("HGB")
            create_observation(patient: hd_patients[0], description: hgb, result: 9)
            create_observation(patient: hd_patients[1], description: hgb, result: 10)
            create_observation(patient: hd_patients[2], description: hgb, result: 11)
            create_observation(patient: hd_patients[3], description: hgb, result: 14)

            # FER
            fer = create_observation_description("FER")
            create_observation(patient: hd_patients[0], description: fer, result: 140)
            create_observation(patient: hd_patients[1], description: fer, result: 150)
            create_observation(patient: hd_patients[2], description: fer, result: 205)

            # TODO: EPO ...

            _columns, values = Reporting::GenerateAuditJson.call(audit_view_name)
            expect(values).to eq(
              [
                [
                  "HD",     # modality
                  4,        # count of hd patients
                  "11.00",  # avg_hgb (9 + 10 + 11 + 14) / 4 = 11
                  "75.00",  # pct_hgb_gt_eq_10 = all bar 1 = 75%
                  "50.00",  # pct_hgb_gt_eq_11 = 2 = 50%
                  "25.00",  # pct_hgb_gt_eq_13 = 1 = 25%
                  "165.00", # avg_fer = (140 + 150 + 205) / 3 = 165
                  "66.67",  # pct_fer_gt_eq_150 = 2 of 3 = 66.66
                  0         # no_on_epo
                ],
                [
                  "PD",
                  1,
                  nil,
                  "0.00",
                  "0.00",
                  "0.00",
                  nil,
                  "0.00",
                  0
                ]
              ]
            )
          end
        end
      end
    end
  end
end
