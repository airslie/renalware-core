module Renalware
  module Feeds
    class ProcessFeedMessagesJob < ApplicationJob
      # A good-job-cron-scheduled job that looks for rows in feed_msg_queue, where each row is
      # an imperative to create a new background job to process (import) the specified feed_msg.
      # We use a separate table for these instructions to avoid querying the very large
      # feed_msgs table.
      # Note that if for instance ActiveJob is paused, the items in the MsgQueue will build up
      # and its is possible that we might have two rows referencing the same msg. This is
      # because a partial ORU for with ORC FON '123' might arrive, followed a few hours later by
      # say a final message with the same ORU. The second message updates the msg created by
      # the first, but both add a distinct entry into MsgQueue. Since both entries in the
      # point to the same (updated) Msg, then we can safely only process one of them and
      # ignore the other, hence the processed_msg_ids below which tracks already-imported
      # feed_msg_ids
      def perform
        processed_msg_ids = []
        MsgQueue.find_each do |queue_item|
          # We use a Tx around the two database operations as we do not want to delete the
          # queue item unless we are sure we have added a background job
          MsgQueue.transaction do
            unless processed_msg_ids.include?(queue_item.feed_msg_id)
              ProcessFeedMessageJob.perform_later(msg_id: queue_item.feed_msg_id)
              processed_msg_ids << queue_item.feed_msg_id
            end
            queue_item.destroy!
          end
        end
      end
    end
  end
end
