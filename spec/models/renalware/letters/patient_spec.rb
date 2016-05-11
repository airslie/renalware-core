require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  module Letters
    describe Patient, type: :model do
      include LettersSpecHelper

      subject(:patient) { build(:letter_patient) }

      describe "#cc_on_letter?" do
        context "given the letter belongs to the patient" do
          context "and the patient is the main recipient" do
            let(:letter) { build_letter(to: :patient, patient: patient) }

            it { expect(patient.cc_on_letter?(letter)).to be_falsy }
          end

          context "and the doctor is the main recipient" do
            let(:letter) { build_letter(to: :doctor, patient: patient) }

            context "and patient requested to be CCd on all letters" do
              before { patient.cc_on_all_letters = true }

              it { expect(patient.cc_on_letter?(letter)).to be_truthy }
            end

            context "and patient did not request to be CCd on all letters" do
              before { patient.cc_on_all_letters = false }

              it { expect(patient.cc_on_letter?(letter)).to be_falsy }
            end
          end
        end

        context "given the letter belongs to another patient" do
          let(:another_patient) { build(:letter_patient) }
          let(:letter) { build_letter(to: :patient, patient: another_patient) }

          it { expect(patient.cc_on_letter?(letter)).to be_falsy }
        end
      end
    end
  end
end