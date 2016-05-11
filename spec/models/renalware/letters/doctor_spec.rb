require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  module Letters
    describe Doctor, type: :model do
      include LettersSpecHelper

      subject(:doctor) { create(:letter_doctor) }

      describe "#cc_on_letter?" do
        let(:patient) { create(:letter_patient, doctor: doctor) }

        context "given the letter is for another doctor" do
          let(:other_doctor) { build(:letter_doctor) }
          let(:other_patient) { build(:letter_patient, doctor: other_doctor) }
          let(:letter) { build_letter_to(:other_patient, patient: other_patient) }

          it { expect(doctor.cc_on_letter?(letter)).to be_falsy }
        end

        context "given the letter is for the patient" do
          let(:letter) { build_letter_to(:patient, patient: patient) }

          it { expect(doctor.cc_on_letter?(letter)).to be_truthy }
        end

        context "given the letter is for the doctor" do
          let(:letter) { build_letter_to(:doctor, patient: patient) }

          it { expect(doctor.cc_on_letter?(letter)).to be_falsy }
        end

        context "given the letter is for someone else" do
          let(:letter) { build_letter_to(:other, patient: patient) }

          it { expect(doctor.cc_on_letter?(letter)).to be_truthy }
        end
      end
    end
  end
end
