# frozen_string_literal: true

module Renalware
  module Feeds
    class ReplayRequest < ApplicationRecord
      validates :started_at, presence: true
      validates :patient, presence: true
      has_many :message_replays, dependent: :destroy
      belongs_to :patient, class_name: "Renalware::Patient"

      def self.policy_class = BasePolicy

      # Class method creates and yields a new replay_request which spans an
      # entire replay operation
      def self.start_logging(patient)
        log_ongoing_replay(patient) && return if another_replay_ongoing?(patient)

        replay_request = create!(started_at: Time.zone.now, patient: patient)
        yield replay_request
      ensure
        replay_request&.update!(finished_at: Time.zone.now)
      end

      # Return true if we found another unfinished replay - we want to avoid re-entry
      def self.another_replay_ongoing?(patient)
        exists?(patient_id: patient.id, finished_at: nil)
      end

      def self.log_ongoing_replay(patient)
        create!(
          patient: patient,
          started_at: Time.zone.now,
          finished_at: Time.zone.now,
          error_message: "An unfinished replay found for patient #{patient.id} so cannot " \
                        "continue. Please add a finished_at datetime to that row if it has " \
                        "stalled/failed for any reason and retry"
        )
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
