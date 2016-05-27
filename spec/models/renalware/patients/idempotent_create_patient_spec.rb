require "rails_helper"

module Renalware::Patients
  RSpec.describe IdempotentCreatePatient do
    describe "#call" do
      let!(:system_user) { create(:user, username: ::Renalware::SystemUser.username) }

      context "given a patient does not have the same hospital number" do
        let(:params) { { patient: attributes_for(:patient) } }

        subject(:command) { IdempotentCreatePatient.new(params) }

        it "creates the patient" do
          expect{command.call}.to change{::Renalware::Patient.count}.by(1)
        end
      end

      context "give a patient has the same hospital number" do
        let!(:existing_patient) { create(:patient, local_patient_id: "SAME-12345") }
        let(:params) do
          {
            patient: attributes_for(:patient).merge(
              local_patient_id: existing_patient.local_patient_id
            )
          }
        end

        subject(:command) { IdempotentCreatePatient.new(params) }

        it "does not create the patient" do
          expect{command.call}.not_to change{::Renalware::Patient.count}
        end
      end
    end
  end
end
