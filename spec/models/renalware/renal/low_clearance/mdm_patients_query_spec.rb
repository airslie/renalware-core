require "rails_helper"

module Renalware
  module Renal
    module LowClearance
      RSpec.describe MDMPatientsQuery, type: :query do
        include PatientsSpecHelper
        let(:user) { create(:user) }

        def create_lcc_patient
          create(:patient).tap do |patient|
            set_modality(patient: patient,
                         modality_description: create(:lcc_modality_description),
                         by: user)
          end
        end

        context "when unfiltered" do
          it "returns only LCC patients" do
            lcc_patient = create_lcc_patient
            create(:patient)

            patients = described_class.new(named_filter: nil, q: {}).call

            expect(patients.to_a).to eq [lcc_patient]
          end
        end

        describe "filters" do
          describe "#on_worryboard" do
            it "returns only patients on the worryboard" do
              create_lcc_patient
              lcc_patient_with_worry = create_lcc_patient
              Renalware::Patients::Worry.new(patient: lcc_patient_with_worry, by: user).save!

              patients = described_class.new(named_filter: :on_worryboard).call

              expect(patients.to_a).to eq [lcc_patient_with_worry]
            end
          end

          describe "#tx_candidates" do
            it "returns only patients with a registration status" do
              create_lcc_patient
              lcc_patient_on_tx_wait_list = create_lcc_patient

              create(
                :transplant_registration,
                :in_status,
                status: "active",
                patient: Renalware::Transplants.cast_patient(lcc_patient_on_tx_wait_list)
              )

              patients = described_class.new(named_filter: :tx_candidates).call

              pending "Need to implement this filter"
              expect(patients.to_a).to eq [lcc_patient_on_tx_wait_list]
            end
          end
        end
      end
    end
  end
end
