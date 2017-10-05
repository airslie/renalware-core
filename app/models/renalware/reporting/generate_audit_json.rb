require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class GenerateAuditJson
      def self.call(view_name)
        conn = ActiveRecord::Base.connection
        result = conn.execute("select * from #{conn.quote_column_name(view_name)};")

        # Build a JS DataTables-compatible columnDefs hash
        columns = result.fields.each_with_index.inject([]) do |array, data|
          column_name, index = data
          array << { title: column_name, target: index }
        end
        [columns.to_json, result.values]
      end

      # A WIP to translate audit column names into human friendly ones.
      # May need to establish guidelines for instance apply text case in the view itself so
      # eg pct_HGB = % HGB without having to know to upcase certain bits of the name but
      # capitalise others etc.
      # def self.humanize_column_name(column)
      #   column
      #     .gsub("pct_", "% ")
      #     .gsub("count_", "No.")
      #     .gsub("avg_", "Avg ")
      #     .gsub("max", "Max ")
      #     .gsub("gt_eq_", "≥ ")
      #     .gsub("lt_eq_", "≤ ")
      #     .gsub("gt_", "> ")
      #     .gsub("lt_", "< ")
      # end
    end
  end
end
