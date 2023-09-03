# frozen_string_literal: true

module Renalware
  module Feeds
    class ReplayRequest < ApplicationRecord
      validates :started_at, presence: true
      has_many :message_replays, dependent: :destroy

      # Class method creates and yields a new replay_request which spans an
      # entire replay operation
      def self.start_logging
        replay_request = create!(started_at: Time.zone.now)
        yield replay_request
      ensure
        replay_request.update!(finished_at: Time.zone.now)
      end

      # Instance method logs the results of an individual replay of a feed_message
      def log(feed_message)
        self.total_messages += 1
        msg_replay = message_replays.create!(message: feed_message)
        yield
        feed_message.update!(processed: true)
        msg_replay.success = true
      rescue StandardError => e
        self.failed_messages += 1
        msg_replay.error_message = e.message
        msg_replay.success = false
      ensure
        save!
        msg_replay.save!
      end
    end
  end
end
