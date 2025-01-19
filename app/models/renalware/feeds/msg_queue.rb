module Renalware
  module Feeds
    class MsgQueue < ApplicationRecord
      self.table_name = :feed_msg_queue
    end
  end
end
