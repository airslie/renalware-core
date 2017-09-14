require_dependency "renalware/messaging"

module Renalware
  module Messaging
    module Internal
      class Receipt < ApplicationRecord
        validates :recipient, presence: true
        validates :message, presence: true

        belongs_to :message
        belongs_to :recipient

        scope :unread, -> { where(read_at: nil) }

        def read?
          read_at.present?
        end
      end
    end
  end
end
