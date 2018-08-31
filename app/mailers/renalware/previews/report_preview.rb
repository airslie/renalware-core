# frozen_string_literal: true

module Renalware
  module Reporting
    # Preview all emails at http://localhost:3000/rails/mailers/report
    class ReportPreview < ActionMailer::Preview
      def daily_summary
        Reporting::ReportMailer.daily_summary(to: "dev@airslie.com")
      end
    end
  end
end
