# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    module Mailshots
      # Called via ajax from the new mailshot form, and responsible for taking the
      # SQL view the user has chosen as the mailshot datasource, and returning a list of
      # patients that the user can see and check before going on to create the mailshot.
      class PatientPreviewsController < BaseController
        def index
          authorize Patient, :index?
          render locals: {
            patients: Mailshot.new(sql_view_name: sql_view_name).recipient_patients,
            datasource: DataSource.find_by(viewname: sql_view_name)
          }
        end

        private

        # The user will have selected a view name from the dropdown onm the form.
        # This is the name of a SQL view in the database in the format
        # letter_mailshot_xxxxxx eg letter_mailshot_tx_patients.
        # See help text on the html form for an example of a SQL view.
        def sql_view_name
          params.dig(:mailshot, :sql_view_name)
        end
      end
    end
  end
end
