# frozen_string_literal: true

module Renalware
  module Messaging
    module Internal
      class Recipient < ActiveType::Record[Renalware::User]
        # rubocop:disable Rails/RedundantForeignKey
        has_many :receipts, dependent: :destroy, foreign_key: :recipient_id
        # rubocop:enable Rails/RedundantForeignKey
        has_many :messages, through: :receipts
      end
    end
  end
end
