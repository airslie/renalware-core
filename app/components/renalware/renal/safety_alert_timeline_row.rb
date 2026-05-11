# frozen_string_literal: true

module Renalware
  class Renal::SafetyAlertTimelineRow < TimelineRow
    private

    def type
      TableCell do
        @record.resolved? ? "Safety Alert (resolved)" : "Safety Alert"
      end
    end

    def description
      TableCell { @record.rule_name.truncate(40) }
    end

    def created_by = TableCell { "System User" }

    def detail
      TableDetailRow(COLUMNS) do
        dl(class: "dl-horizontal xlarge") do
          dt(class: "text-right") { "Notes" }
          dd { @record.notes.presence || "No notes recorded" }
        end
      end
    end
  end
end
