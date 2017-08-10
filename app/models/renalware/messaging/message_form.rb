require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class MessageForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :body, String
      attribute :subject, String
      attribute :urgent, Boolean, default: false
      attribute :recipient_ids, Array, default: []

      validates :body, presence: true
      validates :subject, presence: true
      validates :recipient_ids, presence: true, length: { minimum: 1 }

      def initialize(attributes = {})
        remove_blank_recipient_ids_from(attributes)
        super
      end

      private

      def remove_blank_recipient_ids_from(params)
        params[:recipient_ids].reject!(&:blank?) if params.key?(:recipient_ids)
      end
    end
  end
end
