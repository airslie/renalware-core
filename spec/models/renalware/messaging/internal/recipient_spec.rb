# frozen_string_literal: true

require "rails_helper"

module Renalware::Messaging::Internal
  describe Recipient, type: :model do
    it { is_expected.to have_many(:messages).through(:receipts) }
    it { is_expected.to have_many(:receipts).class_name("Renalware::Messaging::Internal::Receipt") }
  end
end
