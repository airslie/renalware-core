module Renalware
  module Medications
    class ExpiringHDPrescriptionsDateRange
      def range = start_date..end_date

      private

      def config      = Renalware.config
      def start_date  = days_behind.days.ago.beginning_of_day
      def end_date    = days_ahead.days.from_now.end_of_day
      def days_ahead  = config.days_ahead_to_warn_named_consultant_about_expiring_hd_prescriptions
      def days_behind = config.days_behind_to_warn_named_consultant_about_expired_hd_prescriptions
    end
  end
end
