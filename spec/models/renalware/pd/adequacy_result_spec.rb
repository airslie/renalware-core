# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe AdequacyResult, type: :model do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_presence_of(:performed_on)
      end

      describe "derivation of calculated attributes before saving" do
        let(:patient) { create(:pd_patient) }

        context "when there is no recent visit" do
          it "does not update the calculated columns" do
            result = create(:pd_adequacy_result, patient: patient)

            expect(result.dietry_protein_intake).to be_nil
          end
        end

        context "when the last visit has no weight" do
          it "does not update the calculated columns" do
            create(:clinic_visit, patient_id: patient.id, weight: 0)
            result = create(:pd_adequacy_result, patient: patient)

            expect(result.dietry_protein_intake).to be_nil
          end
        end

        context "when the last visit has a weight" do
          it "updates the calculated columns" do
            create(:clinic_visit, patient_id: patient.id, weight: 100)
            result = create(:pd_adequacy_result, patient: patient)

            expect(result.dietry_protein_intake).to be > 0
          end
        end
      end
    end
  end
end
