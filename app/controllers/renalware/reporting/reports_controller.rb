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
          :pagination!
        ]
      end

      def index
        authorize Audit, :index?
        render locals: { reports: reports }
      end

      def show
        sql_view_klass = SqlView.new(view_name).klass
        sql_view_klass.reset_column_information
        search = sql_view_klass.ransack(params[:q])
        # view_proc = ->(patient) { patient_transplants_mdm_path(patient_id: patient.secure_id) }
        pagy, rows = pagy(search.result)
        options = ReportOptions.new(
          search: search,
          rows: rows.load, # search.result.page(page).per(5).load,
          current_view: current_view,
          pagination: pagy
        )
        render locals: { options: options }
      end

      private

      def view_name
        "#{current_view.schema_name}.#{current_view.view_name}"
      end

      def reports
        System::ViewMetadata.where(category: :report).order(:title)
      end

      def find_and_authorize_report
        System::ViewMetadata.find(params[:id]).tap { |report| authorize report }
      end

      def current_view
        @current_view ||= find_and_authorize_report
      end
    end
  end
end
