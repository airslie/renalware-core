# frozen_string_literal: true

require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class ReportsController < BaseController
      include Pagy::Backend

      class ReportOptions
        attr_reader_initialize [
          :search!,
          :rows!,
          :current_view!,
          :view_proc,
          :pagination!,
          :report_path_without_params,
          :report_csv_download_path_with_params
        ]
      end

      def index
        authorize Audit, :index?
        render locals: { reports: reports }
      end

      def show
        respond_to do |format|
          format.html { show_html }
          format.csv { show_csv }
        end
      end

      private

      def show_html
        sql_view_klass = build_sql_view_klass
        search = sql_view_klass.ransack(params[:q])
        pagy, rows = pagy(search.result)

        options = ReportOptions.new(
          search: search,
          rows: rows.load, # search.result.page(page).per(5).load,
          current_view: current_view,
          pagination: pagy,
          report_path_without_params: reporting_report_path(current_view),
          report_csv_download_path_with_params: report_csv_download_path_with_params
        )
        render locals: { options: options }
      end

      def show_csv
        sql_view_klass = build_sql_view_klass
        search = sql_view_klass.ransack(params[:q])
        response.headers["Content-Type"] = "text/csv"
        # response.headers["Content-Disposition"] =
        #   "attachment; filename=report_#{current_view.id}_#{Time.zone.now}.csv"

        send_data(
          sql_view_klass.to_csv(search.result.load),
          filename: "rw-report-#{current_view.id}-#{Time.zone.now.strftime('%d%m%Y%H%M')}.csv"
        )
      end

      def report_csv_download_path_with_params
        reporting_report_path(
          current_view,
          format: :csv,
          params: request.params.slice("q")
        )
      end

      def view_name
        "#{current_view.schema_name}.#{current_view.view_name}"
      end

      def build_sql_view_klass
        @build_sql_view_klass ||= SqlView.new(view_name).klass.tap(&:reset_column_information)
      end

      def reports
        System::ViewMetadata.where(category: :report).order(:title)
      end

      def find_and_authorize_report
        @find_and_authorize_report ||=
          System::ViewMetadata.find(params[:id]).tap { |report| authorize report }
      end

      def current_view
        @current_view ||= find_and_authorize_report
      end
    end
  end
end
