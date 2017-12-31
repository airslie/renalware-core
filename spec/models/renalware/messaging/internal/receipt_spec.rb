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
      it { is_expected.not_to be_read }

      it "returns true if read_at is set" do
        expect(described_class.new(read_at: Time.zone.now)).to be_read
      end
    end
  end
end
