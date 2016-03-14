require "rails_helper"

module Renalware::Patients
  RSpec.describe CreatePatient do
    describe "#call" do
      context "given a patient does not have the same hospital number" do
        it "creates the patient" do
          params = {patient: attributes_for(:patient)}

          expect{subject.call(params)}.to change{::Renalware::Patient.count}.by(1)
        end
      end

      context "give a patient has the same hospital number" do
        before do
          create(:patient, local_patient_id: "SAME-12345")
        end
        it "does not create the patient" do
          params = {patient: attributes_for(:patient).merge(local_patient_id: "SAME-12345")}

          expect{subject.call(params)}.not_to change{::Renalware::Patient.count}
        end
      end
    end
  end
end
