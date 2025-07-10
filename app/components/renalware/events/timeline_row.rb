# frozen_string_literal: true

module Renalware
  class Events::TimelineRow < TimelineRow
    private

    def type = TableCell { "Event" }
    def description = TableCell { @record.event_type.name }

    def detail
      TableDetailRow(COLUMNS) do
        klass = NameService.from_model(@record, to: "Detail", keep_class: true)
        render klass.new(@record)
      end
    end
  end
end
