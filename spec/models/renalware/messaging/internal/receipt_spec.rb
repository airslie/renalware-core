require "rails_helper"

module Renalware::Messaging::Internal
  describe Receipt, type: :model do
    it { is_expected.to validate_presence_of(:recipient) }
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to have_db_index(:recipient_id) }
    it { is_expected.to have_db_index(:message_id) }
    it { is_expected.to belong_to(:message).class_name("Renalware::Messaging::Internal::Message") }
    it { is_expected.to belong_to(:recipient) }

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
