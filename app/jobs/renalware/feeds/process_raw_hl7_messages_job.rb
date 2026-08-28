module Renalware
  module Feeds
    # Called at a regular intervals eg by good_job.cron to pick up records in the RawHL7Message
    # table, and process them into Feeds::Message
    # Process messages in FIFO order.
    class ProcessRawHL7MessagesJob < ApplicationJob
      # To ensure only one thread per process services this queue set
      # (eg where GOOD_JOB_MAX_THREADS=5)
      # GOOD_JOB_QUEUES=hl7_raw_ingestion:1;-hl7_raw_ingestion:4
      queue_as :hl7_raw_ingestion

      RAW_HL7_PROCESSING_ADVISORY_LOCK_KEY = 1_530_019_851

      def perform
        return process_raw_hl7_messages if Renalware.config.bypass_raw_hl7_processing_advisory_lock

        with_raw_hl7_processing_lock do
          process_raw_hl7_messages
        end
      end

      private

      def with_raw_hl7_processing_lock
        ActiveRecord::Base.connection_pool.with_connection do |connection|
          if raw_hl7_processing_lock_acquired?(connection)
            begin
              yield
            ensure
              release_raw_hl7_processing_lock(connection)
            end
          else
            Rails.logger.info("#{self.class.name} skipped; another raw HL7 job is already running")
          end
        end
      end

      # rubocop:disable-next Metrics/MethodLength
      def process_raw_hl7_messages
        RawHL7Message
          .order(sent_at: :asc, created_at: :asc)
          .find_each(batch_size: 100) do |raw_message|
          # Will keep doing same ones over and over if there's a problem processing one
          # Not sure how to fix this?
          # How to move the one failure on and process the rest?
          begin
            0 / 0 if raw_message.body&.include?("DIVIDE_BY_ZERO") # Simulate an error for testing
            ProcessRawHL7MessageJob.perform_now(message: raw_message.body.tr("\r", "\n"))
          rescue StandardError => e
            RawHL7MessageError.create!(
              body: raw_message.body,
              sent_at: raw_message.sent_at,
              error_message: e.message,
              error_message_backtrace: e.backtrace.join("\n")
            )
          end
          raw_message.destroy
        end
      end

      def raw_hl7_processing_lock_acquired?(connection)
        connection.select_value(
          "SELECT pg_try_advisory_lock(#{RAW_HL7_PROCESSING_ADVISORY_LOCK_KEY})"
        )
      end

      def release_raw_hl7_processing_lock(connection)
        connection.select_value(
          "SELECT pg_advisory_unlock(#{RAW_HL7_PROCESSING_ADVISORY_LOCK_KEY})"
        )
      end
    end
  end
end
