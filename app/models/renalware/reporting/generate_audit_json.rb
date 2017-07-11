require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class GenerateAuditJson
      def self.call(materialized_view_name)
        result = ActiveRecord::Base.connection.execute(
          "select * from #{materialized_view_name};"
        )
        # Build a datatables compatible columnDefs hash
        columns = result.fields.each_with_index.inject([]) do |array, data|
          column_name, index = data
          array << { title: column_name, target: index }
        end
        [columns.to_json, result.values]
      end
    end
  end
end
