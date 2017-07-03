require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class GenerateAuditJson
      def self.call(materialized_view_name)
        result = ActiveRecord::Base.connection.execute(
          "select * from #{materialized_view_name};"
        )
        { data: result.values }.to_json
      end
    end
  end
end
