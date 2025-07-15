# frozen_string_literal: true

module Renalware
  class Events::TimelineRow < TimelineRow
    private

    def type = TableCell { "Event" }
    def description = TableCell { @record.event_type.name }

    def detail
      TableDetailRow(COLUMNS) do
        render NameService
          .from_model(@record, to: "Detail", keep_class: true)
          .new(@record)
      end
    end
  end
end
