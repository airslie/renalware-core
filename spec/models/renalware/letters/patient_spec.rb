require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  module Letters
    describe Patient, type: :model do
      include LettersSpecHelper

      subject(:patient) { create(:letter_patient) }

      describe "#cc_on_letter?" do
        context "given the letter is for another patient" do
          let(:another_patient) { build(:letter_patient) }
          let(:letter) { build_letter(to: :patient, patient: another_patient) }

          it { expect(patient.cc_on_letter?(letter)).to be_falsy }
        end

        context "given the letter is for the patient" do
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it { expect(patient.cc_on_letter?(letter)).to be_falsy }
        end

        context "given the letter is for the doctor" do
          let(:letter) { build_letter(to: :doctor, patient: patient) }

          context "given patient requested to be CCd on all letters" do
            before { patient.cc_on_all_letters = true }

            it { expect(patient.cc_on_letter?(letter)).to be_truthy }
          end

          context "given patient did not request to be CCd on all letters" do
            before { patient.cc_on_all_letters = false }

            it { expect(patient.cc_on_letter?(letter)).to be_falsy }
          end
        end
      end
    end
  end
end
