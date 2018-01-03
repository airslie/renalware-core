require "rails_helper"

module Renalware
  describe Letters::ApproveLetter do
    it "broadcasts a letter_approved event when the letter is approved successfully" do
      letter = instance_double(Letters::Letter::PendingReview, archive_recipients!: nil)
      user = build_stubbed(:user)
      cmd = described_class.build(letter)

      allow(letter).to receive(:sign).with(by: user).and_return(letter)
      allow(letter).to receive(:save!).and_return(true)
      allow(letter).to receive(:generate_archive).with(by: user).and_return(letter)

      expect {
        cmd.call(by: user)
      }.to broadcast(:letter_approved, letter)
    end
  end
end
