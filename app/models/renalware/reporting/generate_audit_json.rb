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
    end
  end
end
