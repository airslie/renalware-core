require "rails_helper"

module Renalware
  module Letters
    describe PrimaryCarePhysician, type: :model do
      include LettersSpecHelper

      subject(:primary_care_physician) { build(:letter_primary_care_physician) }

      describe "#cc_on_letter?" do
        context "given the Primary Care Physician is assigned to the patient" do
          let(:patient) { build(:letter_patient, primary_care_physician: primary_care_physician) }

          context "and the patient is the main recipient" do
            let(:letter) { build_letter(to: :patient, patient: patient) }

            it { expect(primary_care_physician.cc_on_letter?(letter)).to be_truthy }
          end

          context "and the Primary Care Physician is the main recipient" do
            let(:letter) { build_letter(to: :primary_care_physician, patient: patient) }

            it { expect(primary_care_physician.cc_on_letter?(letter)).to be_falsy }
          end

          context "and someone else is the main recipient" do
            let(:letter) { build_letter(to: :contact, patient: patient) }

            it { expect(primary_care_physician.cc_on_letter?(letter)).to be_truthy }
          end
        end

        context "given the patient is assigned to another Primary Care Physician" do
          let(:other_primary_care_physician) { build(:letter_primary_care_physician) }
          let(:patient) { build(:letter_patient, primary_care_physician: other_primary_care_physician) }
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it { expect(primary_care_physician.cc_on_letter?(letter)).to be_falsy }
        end
      end
    end
  end
end
