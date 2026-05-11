# frozen_string_literal: true

module Renalware
  class Renal::SafetyAlertTimelineItem < TimelineItem
    private

    def scope
      Renal::SafetyAlert
    end
  end
end
