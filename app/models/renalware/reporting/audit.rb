require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class Audit < ApplicationRecord
      validates :name, presence: true
      validates :materialized_view_name, presence: true
      validates :refresh_schedule, presence: true

      def self.available_audit_materialized_views
        result = connection.execute("SELECT oid::regclass::text FROM pg_class
                                     WHERE  relkind = 'm' and relname like 'reporting_%';")
        result.values.flatten
      end
    end
  end
end
