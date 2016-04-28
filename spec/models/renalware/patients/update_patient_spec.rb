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

        it " broadcasts :patient_updated" do
          expect_subject_to_broadcast(:patient_updated, instance_of(Renalware::Patient))

          subject.call(patient.id, params)
        end
      end

      context "give invalid patient attributes" do
        let(:params) { attributes_for(:patient, given_name: nil) }

        it " broadcasts :patient_update_failed" do
          expect_subject_to_broadcast(:patient_update_failed, instance_of(Renalware::Patient))

          subject.call(patient.id, params)
        end
      end
    end

    def expect_subject_to_broadcast(*args)
      expect(subject).to receive(:broadcast).with(*args)
    end
  end
end
