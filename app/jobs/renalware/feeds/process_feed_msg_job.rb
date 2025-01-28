module Renalware
  module Feeds
    class ProcessFeedMsgJob < ApplicationJob
      def perform(msg_id)
        Msg.find(msg_id).update_column(:processed_at, Time.zone.now)
      end
    end
  end
end
