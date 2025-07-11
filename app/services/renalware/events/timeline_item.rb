# frozen_string_literal: true

module Renalware
  class Events::TimelineItem < TimelineItem
    private

    def scope
      Events::Event.eager_load(:event_type)
    end
  end
end
