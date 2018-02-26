require "rails_helper"

module Renalware
  module Letters
    describe ElectronicReceipt, type: :model do
      it { is_expected.to belong_to(:letter).touch(true) }
      it { is_expected.to have_db_index(:recipient_id) }
      it { is_expected.to have_db_index(:letter_id) }
      it { is_expected.to validate_presence_of(:letter) }
      it { is_expected.to validate_presence_of(:recipient_id) }

      describe "#read?" do
        it "has an initial value of false" do
          expect(subject).not_to be_read
        end
        it "returns true if read_at is set" do
          subject.read_at = Time.zone.now
          expect(subject).to be_read
        end
      end
    end
  end
end
