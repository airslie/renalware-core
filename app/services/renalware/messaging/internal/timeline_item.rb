# frozen_string_literal: true

module Renalware
  class Messaging::Internal::TimelineItem < TimelineItem
    private

    def scope
      Messaging::Message
    end
  end
end
