require_dependency "renalware/messaging"

module Renalware
  module Messaging
    module Internal
      class Message < Renalware::Messaging::Message
        belongs_to :author
        has_many :receipts
        has_many :recipients, through: :receipts
        belongs_to :replying_to_message, class_name: name
      end
    end
  end
end
