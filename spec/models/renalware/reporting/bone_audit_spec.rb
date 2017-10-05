require "rails_helper"

module Renalware
  RSpec.describe Reporting::GenerateAuditJson, type: :model do
    include PatientsSpecHelper

    def create_observation(patient:, description:, result:)
      request = create(:pathology_observation_request, patient: patient)
      create(:pathology_observation,
       request: request,
       description: description,
       result: result
     )
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
          it "is correct aggregated data" do
            user = create(:user)
            hd_patient1 = create(:pathology_patient, by: user)
            hd_patient2 = create(:pathology_patient, by: user)
            pd_patient = create(:pathology_patient, by: user)
            uom = create(:pathology_measurement_unit)

            set_modality(patient: hd_patient1,
                         modality_description: create(:hd_modality_description),
                         by: user)

            set_modality(patient: hd_patient2,
                         modality_description: create(:hd_modality_description),
                         by: user)

            set_modality(patient: pd_patient,
                         modality_description: create(:pd_modality_description),
                         by: user)

            # cca_observation_description = create(
            #   :pathology_observation_description,
            #   code: "CCA",
            #   measurement_unit: uom
            # )

            # pth_observation_description = create(
            #   :pathology_observation_description,
            #   code: "PTH",
            #   measurement_unit: uom
            # )

            phos_observation_description = create(
              :pathology_observation_description,
              code: "PHOS",
              measurement_unit: uom
            )

            create_observation(
              patient: hd_patient1,
              description: phos_observation_description,
              result: 2.0
            )

            create_observation(
              patient: hd_patient2,
              description: phos_observation_description,
              result: 1.0
            )

            _columns, values = Reporting::GenerateAuditJson.call("reporting_bone_audit")
            expect(values).to eq(
              [
                ["HD", 2, nil, nil, nil, nil, "1.50", "2.0", "50"],
                ["PD", 1, nil, nil, nil, nil, nil, nil, nil]
              ]
            )
          end
        end
      end
    end
  end
end
