module Renalware
  module Feeds
    class Msg < ApplicationRecord
      validates :message_control_id, presence: true
      validates :message_type, presence: true
      validates :event_type, presence: true
      validates :body, presence: true
      validates :sent_at, presence: true
    end
  end
end
