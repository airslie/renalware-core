# frozen_string_literal: true

module Renalware
  module Feeds
    # Called at a regular intervals eg by good_job.cron to pick up records in the RawHL7Message
    # table. Process messages in FIFO order.
    class ProcessRawHL7MessagesJob < ApplicationJob
      def perform
        # Fetch messages in batches of (up to) n in size, and for each batch
        # - create corresponding active jobs in one INSERT statement by using GoodJob::Bulk.enqueue
        # - delete the raw HL7 rows, again in one query with no callbacks.
        # There is a risk that if there are several thousand items in the table,
        # and the cron frequency for this job class is too regular, we might re-enter before all
        # records are processed, and end up with two running batch loops fighting over the same
        # jobs. However:
        # - I don't think this will happen unless there is a very unusual build up of messages or
        #   the cron entry is misconfigured
        # - In the event it happens we might enqueue some jobs twice, but as we discard duplicate
        #   HL7 messages downstream, I don't think this is a problem
        # - delete_all does not baulk if not all (or no) matching rows are found (ie already
        #   deleted) so can safely be run without contention between two running batched loops.
        # We _could_ wrap the lot in a transaction, but I am currently unsure of the impact of doing
        # this with good_job.
        RawHL7Message.order(created_at: :asc).in_batches(of: 50) do |relation|
          GoodJob::Bulk.enqueue do
            relation.each do |raw_msg|
              ProcessRawHL7MessageJob.perform_later(message: raw_msg.body.tr("\r", "\n"))
            end
          end
          relation.delete_all
        end
      end
    end
  end
end
