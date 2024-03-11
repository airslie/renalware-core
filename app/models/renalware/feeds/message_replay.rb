# frozen_string_literal: true

module Renalware
  module Feeds
    # Captures when a feed message has been replayed. See ReplayRequest.
    class MessageReplay < ApplicationRecord
      validates :replay_request_id, presence: true
      validates :message_id, presence: true

      belongs_to :replay_request
      belongs_to :message

      def self.policy_class = BasePolicy
    end
  end
end
