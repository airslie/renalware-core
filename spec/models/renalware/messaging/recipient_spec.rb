require "rails_helper"

module Renalware::Messaging
  describe Recipient, type: :model do
    it { is_expected.to have_many(:receipts) }
    it { is_expected.to have_many(:messages).through(:receipts) }
  end
end
