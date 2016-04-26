require "rails_helper"

module Renalware::Patients
  RSpec.describe UpdatePatient do
    let(:patient) { create(:patient) }

    describe "#call" do
      context "given valid patient attributes" do
        it "updates the patient" do
          params = attributes_for(:patient, given_name: "RABBIT")

          expect(subject.call(patient.id, params)).to be_truthy
          expect(patient.reload.given_name).to eq("RABBIT")
        end
      end

      context "give invalid patient attributes" do
        it "does not update the patient" do
          params = attributes_for(:patient, given_name: nil)

          expect(subject.call(patient.id, params)).to be_falsy
        end
      end
    end
  end
end
