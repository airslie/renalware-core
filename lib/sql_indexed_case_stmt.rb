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
# Used for creating an explicit sort order in conjunction with a find:
#
#    Description.where(code: codes).order(indexed_case_stmt(:code, codes))
#
class SqlIndexedCaseStmt
  pattr_initialize :column, :items

  def generate
    return if items.blank?

    statement = Arel::Nodes::Case.new(column_node)
    Array(items).each_with_index do |item, index|
      statement.when(item).then(index)
    end
    statement
  end

  private

  def column_node
    parts = column.to_s.split(".")
    return unqualified_column(parts.first) if parts.one?
    return Arel::Table.new(parts.first)[parts.second] if parts.length == 2

    raise ArgumentError, "Column must be unqualified or table-qualified"
  end

  def unqualified_column(name)
    attribute = Arel::Table.new(:ignored)[name]
    Arel::Nodes::UnqualifiedColumn.new(attribute)
  end
end
