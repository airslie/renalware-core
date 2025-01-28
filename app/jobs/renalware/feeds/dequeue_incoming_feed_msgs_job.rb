module Renalware
  module Feeds
    class DequeueIncomingFeedMsgsJob < ApplicationJob
      # A good-job-cron-scheduled job that looks for rows in feed_msg_queue, where each row is
      # an imperative to create a new background job to process (import) the specified feed_msg.
      # We use a separate table for these instructions to avoid querying the very large
      # feed_msgs table.
      def perform
        MsgQueue.find_each do |queue_item|
          # We use a Tx around the two database operations as we do not want to delete the
          # queue item unless we are sure we have added a background job
          MsgQueue.transaction do
            # Bulk enqueue Active Job instances directly without using `.perform_later`:
            # GoodJob::Bulk.enqueue([MyJob.new, AnotherJob.new])
            ProcessFeedMsgJob.perform_later(queue_item.feed_msg_id)
            queue_item.destroy!
          end
        end
      end
    end
  end
end
