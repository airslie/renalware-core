require "rails_helper"

module Renalware
  module Letters
    describe Doctor, type: :model do
      include LettersSpecHelper

      subject(:doctor) { build(:letter_doctor) }

      describe "#cc_on_letter?" do
        context "given the doctor is assigned to the patient" do
          let(:patient) { build(:letter_patient, doctor: doctor) }

          context "and the patient is the main recipient" do
            let(:letter) { build_letter(to: :patient, patient: patient) }

            it { expect(doctor.cc_on_letter?(letter)).to be_truthy }
          end

          context "and the doctor is the main recipient" do
            let(:letter) { build_letter(to: :doctor, patient: patient) }

            it { expect(doctor.cc_on_letter?(letter)).to be_falsy }
          end

          context "and someone else is the main recipient" do
            let(:letter) { build_letter(to: :other, patient: patient) }

            it { expect(doctor.cc_on_letter?(letter)).to be_truthy }
          end
        end

        context "given the patient is assigned to another doctor" do
          let(:other_doctor) { build(:letter_doctor) }
          let(:patient) { build(:letter_patient, doctor: other_doctor) }
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it { expect(doctor.cc_on_letter?(letter)).to be_falsy }
        end
      end
    end
  end
end
