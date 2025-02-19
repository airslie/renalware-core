module Renalware
  module Reporting
    # Preview all emails at http://localhost:3000/rails/mailers
    class ReportPreview < ActionMailer::Preview
      def daily_summary # rubocop:disable Rails/Delegate
        Reporting::ReportMailer.daily_summary
      end
    end
  end
end
