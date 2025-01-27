module Renalware
  module Feeds
    # Called at a regular intervals eg by good_job.cron to pick up records in the RawHL7Message
    # table, and process them into Feeds::Message
    # Process messages in FIFO order.
    class ProcessRawHL7MessagesJob < ApplicationJob
      def perform
        RawHL7Message
          .order(sent_at: :asc, created_at: :asc)
          .find_each(batch_size: 100) do |raw_message|
          ProcessRawHL7MessageJob.perform_now(message: raw_message.body.tr("\r", "\n"))
          raw_message.destroy
        end
      end
    end
  end
end
