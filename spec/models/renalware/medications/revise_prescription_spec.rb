require "rails_helper"

module Renalware::Medications
  RSpec.describe RevisePrescription do
    let!(:patient) { create(:patient) }
    let(:old_dose_amount) { "100" }
    let!(:prescription) { create(:prescription, patient: patient, dose_amount: old_dose_amount) }

    describe "#call" do
      let!(:user) { create(:user) }
      let(:params) { { dose_amount: new_dose_amount } }
      subject(:command) { RevisePrescription.new(prescription).call(params.merge(by: user)) }

      context "updating the prescription's dose_amount with a valid value" do
        let(:new_dose_amount) { "200" }

        before do
          command
        end

        it "terminates the existing prescription and creates a new one" do
          expect(patient.prescriptions.count).to eq(2)
        end

        it "updates the dose_amount on the new prescription" do
          expect(patient.prescriptions.current.first.dose_amount).to eq(new_dose_amount)
        end

        it "keeps the old dose_amount on the terminated prescription" do
          expect(patient.prescriptions.terminated.first.dose_amount).to eq(old_dose_amount)
        end
      end

      context "updating the prescription's dose_amount with an invalid value" do
        let(:new_dose_amount) { nil }

        before do
          begin
            command
          rescue ActiveRecord::RecordInvalid
            nil
          end
        end

        it "rolls back the transaction" do
          expect(patient.prescriptions.count).to eq(1)
          expect(patient.prescriptions.current.count).to eq(1)
          expect(patient.prescriptions.current.first).to eq(prescription)
          expect(patient.prescriptions.terminated.count).to eq(0)
        end
      end
    end
  end
end
