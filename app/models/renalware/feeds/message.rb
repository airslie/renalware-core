require_dependency "renalware/feeds"

module Renalware
  module Feeds
    # Responsible for persisting the raw message. Useful for audit and
    # debugging purposes.
    #
    class Message < ActiveRecord::Base
      validates :header_id, presence: true
      validates :event_code, presence: true
      validates :body, presence: true

      def to_s
        body
      end
    end
  end
end
