module Renalware
  module Messaging
    module Internal
      class Message < Renalware::Messaging::Message
        include OrderedScope

        ORDER_FIELDS = [:sent_at].freeze

        belongs_to :author, class_name: "Internal::Author"
        has_many :receipts, dependent: :destroy
        has_many :recipients, through: :receipts
        belongs_to :replying_to_message, class_name: name
      end
    end
  end
end
