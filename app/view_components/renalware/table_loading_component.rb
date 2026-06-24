module Renalware
  class TableLoadingComponent < ApplicationComponent
    WIDTH_PATTERN = %w(42% 64% 52% 74% 36%).freeze

    attr_reader :columns, :label, :rows

    def initialize(columns: 5, label: "Loading table rows", rows: 3)
      super()
      @columns = columns
      @label = label
      @rows = rows
    end

    def column_width(column_index)
      WIDTH_PATTERN[column_index % WIDTH_PATTERN.length]
    end
  end
end
