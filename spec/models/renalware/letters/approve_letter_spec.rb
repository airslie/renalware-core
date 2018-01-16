require "rails_helper"

module Renalware
  describe Letters::ApproveLetter do
    include LettersSpecHelper
    let(:patient) { create(:letter_patient) }
    let(:user) { create(:user) }

    it "broadcasts a letter_approved event when the letter is approved successfully" do
      letter = create_letter(state: :pending_review, to: :patient, patient: patient)
      approved_letter = letter.becomes(Letters::Letter::Approved)

      expect {
        described_class.build(letter).call(by: user)
      }.to broadcast(:letter_approved, approved_letter)
    end
  end
end
