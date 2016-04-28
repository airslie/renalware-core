require "rails_helper"

module Renalware::Patients
  RSpec.describe UpdatePatient do
    let(:patient) { create(:patient) }

    describe "#call" do
      context "given valid patient attributes" do
        let(:params) { attributes_for(:patient, given_name: "RABBIT") }

        it "updates the patient" do
          subject.call(patient.id, params)

          expect(patient.reload.given_name).to eq("RABBIT")
        end

        it "notifies a listener the patient was updated successfully" do
          listener = spy(:listener)
          subject.subscribe(listener)

          subject.call(patient.id, params)

          expect(listener).to have_received(:update_patient_successful).with(instance_of(Renalware::Patient))
        end
      end

      context "give invalid patient attributes" do
        let(:params) { attributes_for(:patient, given_name: nil) }

        it "notifies a listener the patient update failed" do
          listener = spy(:listener)
          subject.subscribe(listener)

          subject.call(patient.id, params)

          expect(listener).to have_received(:update_patient_failed).with(instance_of(Renalware::Patient))
        end
      end
    end
  end
end
