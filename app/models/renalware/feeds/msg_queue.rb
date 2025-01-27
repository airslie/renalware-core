module Renalware
  module Feeds
    class MsgQueue < ApplicationRecord
      self.table_name = :feed_msg_queue
      validates :feed_msg_id, presence: true
    end
  end
end
