# frozen_string_literal: true

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
        context "when the receipt has not yet been read" do
          subject{ described_class.new }

          it { is_expected.not_to be_read }
        end

        context "when the receipt has been read" do
          subject{ described_class.new(read_at: Time.zone.now) }

          it { is_expected.to be_read }
        end
      end
    end
  end
end
