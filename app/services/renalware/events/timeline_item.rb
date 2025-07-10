# frozen_string_literal: true

module Renalware
  class Events::TimelineItem < TimelineItem
    def detail
      render NameService
        .from_model(@record, to: "Detail", keep_class: true)
        .new(@record)
    end

    private

    def scope
      Events::Event.joins(:event_type)
    end
  end
end
