require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class RefreshAuditDataJob < ApplicationJob
      queue_as :reporting

      # :reek:UtilityFunction
      def perform(audit)
        refresh_materialized_view_associated_with_audit(audit)
        update_audit_refreshment_date(audit)
      end

      private

      def refresh_materialized_view_associated_with_audit(audit)
        Scenic.database.refresh_materialized_view(audit.materialized_view_name,
                                                  concurrently: false,
                                                  cascade: false)
      end

      def update_audit_refreshment_date(audit)
        audit.update!(refreshed_at: Time.zone.now)
      end
    end
  end
end
