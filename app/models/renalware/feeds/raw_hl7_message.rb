module Renalware
  module Feeds
    # HL7 messages are first inserted raw into this table. They're picked up afterwards
    # by a background job, processed and stored into Feeds::Message. This acts as a queue.
    class RawHL7Message < ApplicationRecord
      validates :body, presence: true
      validates :sent_at, presence: true
    end
  end
end
