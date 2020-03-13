# frozen_string_literal: true

module Renalware
  class Admin::PlaygroundsController < BaseController
    def show
      authorize User, :index?
    end

    # Returns test json to display a chart of one obx code over time for a patient
    def pathology_chart_data
      authorize User, :index?
      chart_params = ChartParams.new(params)
      chart = Chart.new(chart_params)
      render json: chart.json
    end

    class Chart
      pattr_initialize :chart_params

      def json
        ActiveRecord::Base.connection.execute(
          Arel.sql(<<-SQL)
            select
              observed_on as x,
              result as y
              from renalware.pathology_chart_data(#{chart_params.patient_id},
                '#{chart_params.obx_code}',
                '#{chart_params.start_date}')
          SQL
        ).to_a
      end
    end

    class ChartParams
      pattr_initialize :params

      def patient_id
        params.fetch("patient_id", "111606")
      end

      def obx_code
        params.fetch("obx", "?")
      end

      def period
        params.fetch("period", "all")
      end

      # Map a period string to a date, eg 6m = 6 months ago
      def start_date
        time = case period
               when "yr" then 1.year.ago
               when "6m" then 6.months.ago
               when "3m" then 3.months.ago
               when "1m" then 1.month.ago
               when "1wk" then 1.week.ago
               else 100.years.ago
               end
        time.to_date.to_s
      end
    end
  end
end
