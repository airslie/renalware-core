require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  module Letters
    describe Doctor, type: :model do
      include LettersSpecHelper

      let(:patient) { create(:letter_patient) }
      let(:doctor) { Letters.cast_doctor(patient.doctor) }

      describe "#cc_on_letter?" do
        context "letter is for another doctor" do
          it "returns false" do
            letter = build_letter_to(:patient)

            expect(doctor.cc_on_letter?(letter)).to be_falsy
          end
        end

        context "letter is sent to patient" do
          let(:letter) { build_letter_to(:patient, patient: patient) }

          it "returns true" do
            expect(doctor.cc_on_letter?(letter)).to be_truthy
          end
        end

        context "letter is sent to doctor" do
          let(:letter) { build_letter_to(:doctor, patient: patient) }

          it "returns false" do
            expect(doctor.cc_on_letter?(letter)).to be_falsy
          end
        end

        context "letter is sent to outsider" do
          let(:letter) { build_letter_to(:outsider, patient: patient) }

          it "returns true" do
            expect(doctor.cc_on_letter?(letter)).to be_truthy
          end
        end
      end
    end
  end
end
