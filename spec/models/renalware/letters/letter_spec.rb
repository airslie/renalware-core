require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Letter, type: :model do
      it { is_expected.to validate_presence_of(:letterhead) }
      it { is_expected.to validate_presence_of(:issued_on) }
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:author) }
      it { is_expected.to validate_presence_of(:state) }
      it { is_expected.to validate_presence_of(:recipient_type) }
      it { is_expected.to validate_presence_of(:description) }

      context "when recipient is other" do
        let(:letter) { Letter.new(recipient_type: :other) }

        it "validates presence of recipient" do
          expect(letter).to_not be_valid
          expect(letter.errors.keys).to include(:recipient)
        end
      end
    end
  end
end