require "rails_helper"

module Renalware::Medications
  RSpec.describe RevisePrescription do
    let(:patient) { create(:patient) }
    let(:original_dose_amount) { "100" }
    let(:original_prescription) { create(:prescription, patient: patient, dose_amount: original_dose_amount) }

    describe "#call" do
      let(:user) { create(:user) }

      context "updating the prescription's dose_amount with a valid value" do
        let(:revised_dose_amount) { "200" }

        before do
          RevisePrescription.new(original_prescription)
                            .call(dose_amount: revised_dose_amount, by: user)
        end

        it "terminates the original prescription and creates a new one" do
          expect(patient.prescriptions.count).to eq(2)
        end

        it "create a new prescription with the specified dose amount" do
          expect(patient.prescriptions.current.first.dose_amount).to eq(revised_dose_amount)
        end

        it "retains the original dose_amount on the terminated prescription" do
          expect(patient.prescriptions.terminated.first.dose_amount).to eq(original_dose_amount)
        end
      end

      context "updating the prescription's dose_amount with an invalid value" do
        before do
          begin
            RevisePrescription.new(original_prescription)
                              .call(dose_amount: nil, by: user)

          rescue ActiveRecord::RecordInvalid
            # noop
          end
        end

        it "rolls back the transaction" do
          expect(patient.prescriptions.count).to eq(1)
          expect(patient.prescriptions.current.first).to eq(original_prescription)
        end
      end
    end
  end
end
