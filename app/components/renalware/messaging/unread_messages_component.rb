# frozen_string_literal: true

module Renalware
  module Messaging
    class UnreadMessagesComponent < ApplicationComponent
      def initialize(user:)
        @user = Messaging::Internal.cast_recipient(user)
      end

      def unread_message_receipts
        @unread_message_receipts ||= begin
          receipts = user
            .receipts
            .includes(message: [:author, :patient])
            .order("messaging_messages.sent_at asc")
            .unread
          CollectionPresenter.new(receipts, Messaging::Internal::ReceiptPresenter)
        end
      end

      private 
      
      attr_reader :user
    end
  end
end
