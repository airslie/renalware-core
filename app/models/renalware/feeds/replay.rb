# frozen_string_literal: true

module Renalware
  module Feeds
    class Replay < ApplicationRecord
      validates :started_at, presence: true
      has_many :replay_messages, dependent: :destroy

      # Class method creates and yields a new replay which spans an entire replay operation
      def self.start_logging
        replay = Replay.create!(started_at: Time.zone.now)
        yield replay
      ensure
        replay.update!(finished_at: Time.zone.now)
      end

      # Instance method logs the results of an individual replay of a feed_message
      def log(feed_message)
        self.total_messages += 1
        replay_msg = replay_messages.create!(message: feed_message)
        yield
        feed_message.update!(processed: true)
        replay_msg.success = true
      rescue StandardError => e
        self.failed_messages += 1
        replay_msg.error_message = e.message
        replay_msg.success = false
      ensure
        save!
        replay_msg.save!
      end
    end
  end
end
