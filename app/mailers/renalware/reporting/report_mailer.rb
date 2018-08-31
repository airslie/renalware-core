# frozen_string_literal: true

require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class ReportMailer < ApplicationMailer
      def daily_summary(to: "")
        mail(
          to: Array(to),
          subject: "Renalware daily summary #{I18n.l(Time.zone.today)}"
        ) do |format|
          format.text { render(locals: { view_data: view_data }) }
          format.html { render(locals: { view_data: view_data }) }
        end
      end

      private

      # Hijacks the reporting mechanism used elswhere for generating reports from json.
      #
      # returns e.g.
      # {
      #   "reporting_daily_letters" => {
      #     "runat" => "2018-08-31T16:51:58.939876+00:00",
      #      "data" => [
      #         [0] {
      #             "letters_created_today" => 0,
      #             "letters_printed_today" => 0
      #         }
      #     ]
      #   },
      #   "another_view" :...
      # }
      def view_data
        reporting_daily_views.each_with_object({}) do |view_name, hash|
          hash[view_name] = JSON.parse(
            Reporting::FetchAuditJson.call(view_name)
          ).with_indifferent_access
        end
      end

      # returns eg ["reporting_daily_pathology", "reporting_daily_letters"]
      def reporting_daily_views
        result = ActiveRecord::Base.connection.execute(<<-SQL)
          SELECT relname FROM pg_class
          WHERE relkind = 'v'
          AND relname like 'reporting_daily_%'
          AND relnamespace IN (
            SELECT oid FROM pg_namespace WHERE nspname = 'renalware'
          ) order by relname desc;
        SQL
        result.values.flatten
      end
    end
  end
end
