# frozen_string_literal: true

module Renalware
  module Feeds
    # Responsible for persisting the raw message. Useful for audit and
    # debugging purposes.
    #
    class Message < ApplicationRecord
      validates :header_id, presence: true
      validates :message_type, presence: true
      validates :event_type, presence: true
      validates :body, presence: true
      has_many :replay_messages, dependent: :destroy

      def to_s
        body
      end
    end
  end
end
