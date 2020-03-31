# frozen_string_literal: true

module Renalware
  class Admin::PlaygroundsController < BaseController
    skip_after_action :verify_policy_scoped

    def show
      authorize User, :index?
      render locals: { form: ChartForm.new(obx_code: "CRE", period: "all") }
    end

    # Returns test json to display a chart of one obx code over time for a patient
    def pathology_chart_data
      authorize User, :index?
      form = ChartForm.new(chart_params)
      chart = Chart.new(form)
      render json: chart.json
    end

    class ChartForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :patient_id, Integer
      attribute :obx_code, String
      attribute :period, String

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

    def chart_params
      return {} unless params.key?(:chart)

      params.require(:chart).permit!
    end

    class Chart
      pattr_initialize :form

      def json
        return {} if form.patient_id.blank?

        ActiveRecord::Base.connection.execute(
          Arel.sql(<<-SQL)
            select
              observed_on as x,
              result as y
              from renalware.pathology_chart_data(#{form.patient_id},
                '#{form.obx_code}',
                '#{form.start_date}')
          SQL
        ).to_a.each_with_object({}) { |h, hash| hash[Date.parse(h["x"])] = h["y"] }
      end
    end
  end
end
