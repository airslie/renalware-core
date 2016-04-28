require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  module Letters
    describe Patient, type: :model do
      include LettersSpecHelper

      let(:patient) { create(:letter_patient) }
      let(:letter) { build_letter_to(:patient, patient: patient) }

      describe "#cc_on_letter?" do
        it "returns true if option is set in its profile" do
          patient.cc_on_all_letters = true

          expect(patient.cc_on_letter?(letter)).to be_truthy
        end

        it "returns false if option not set in its profile" do
          patient.cc_on_all_letters = false

          expect(patient.cc_on_letter?(letter)).to be_falsy
        end

        it "returns false if letter of another patient" do
          patient.cc_on_all_letters = true
          letter = build_letter_to(:patient)

          expect(patient.cc_on_letter?(letter)).to be_falsy
        end
      end
    end
  end
end
