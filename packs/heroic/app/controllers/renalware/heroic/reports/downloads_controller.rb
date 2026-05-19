# frozen_string_literal: true

module Renalware
  module Heroic
    module Reports
      class DownloadsController < Renalware::BaseController
        include Renalware::Concerns::PatientVisibility

        skip_verify_policy_scoped

        def show
          authorize report_definition
          respond_to do |format|
            format.csv { send_csv_data }
          end
        end

        private

        def send_csv_data
          send_data(
            report_definition.to_csv,
            filename: "#{report_definition.name}.csv",
            disposition: "attachment",
            type: "text/csv"
          )
        end

        def report_definition
          @report_definition ||= Definition.find(params[:id])
        end
      end
    end
  end
end
