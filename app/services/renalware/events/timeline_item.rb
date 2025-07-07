# frozen_string_literal: true

module Renalware
  class Events::TimelineItem < Patients::TimelineItem
    def type = "Event"

    def description
      record.event_type.name
    end

    def detail
      component_class.new(record)
    end

    private

    def fetch
      Events::Event.joins(:event_type)
    end

    # FIXME: Not sure knowledge of components should be here
    def component_class
      class_parts = record.class.name.split("::")
      class_name = class_parts.pop
      class_parts << "Detail" << class_name
      class_parts.join("::").constantize
    end
  end
end
