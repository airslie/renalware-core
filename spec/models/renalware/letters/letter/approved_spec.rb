require "rails_helper"

module Renalware::Letters
  describe Letter::Approved do
    include LettersSpecHelper

    let(:user) { build(:user) }
    let(:doctor) { build(:letter_doctor) }
    let(:patient) { build(:letter_patient, doctor: doctor) }

    subject(:letter) { build(:approved_letter, patient: patient) }

    describe "#complete" do
      it "completed the letter" do
        completed_letter = letter.complete(by: user)
        expect(completed_letter).to be_completed
      end
    end
  end
end
