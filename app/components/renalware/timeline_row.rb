# frozen_string_literal: true

module Renalware
  class TimelineRow < TableBody
    COLUMNS = 5

    def initialize(sort_date:, record:, **attrs)
      @sort_date = sort_date
      @record = record
      super(**attrs)
    end

    def view_template
      super do
        TableRow do
          row_toggler
          date
          type
          description
          created_by
        end
        detail
      end
    end

    private

    def row_toggler = RowTogglerCell()
    def date = DateCell(@sort_date)
    def type = raise NotImplementedError
    def description = raise NotImplementedError
    def created_by = TableCell { @record.created_by.full_name }
    def detail = ""
  end
end
