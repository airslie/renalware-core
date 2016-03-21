module SQL
  # Example:
  #
  #     indexed_case_stmt(:code, "DT", "AC", "XY")
  #
  # Will return the string:
  #
  #    CASE code
  #       WHEN 'DT' THEN 1
  #       WHEN 'AC' THEN 2
  #    END
  #
  # Used for creating an explicit sort order in conjustion with a find:
  #
  #    Description.where(code: codes).order(indexed_case_stmt(:code, codes))
  #
  class IndexedCaseStmt
    def initialize(column, items)
      @column = column
      @items = items
    end

    def generate
      clauses = []
      @items.each_with_index do |item, index|
        clauses << "WHEN '#{item}' THEN #{index}"
      end

      "CASE #{@column} #{clauses.join} END"
    end
  end
end
