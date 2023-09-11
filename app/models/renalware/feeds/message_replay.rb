# frozen_string_literal: true

module Renalware
  module Feeds
    class MessageReplay < ApplicationRecord
      validates :replay_request_id, presence: true
      validates :message_id, presence: true

      belongs_to :replay_request
      belongs_to :message
    end
  end
end
