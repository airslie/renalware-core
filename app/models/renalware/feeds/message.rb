require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class Message < ActiveRecord::Base
      validates :event_code, presence: true
      validates :body, presence: true

      def to_s
        @body
      end
    end
  end
end
