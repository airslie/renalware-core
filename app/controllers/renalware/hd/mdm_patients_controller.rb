module Renalware
  module HD
    class MDMPatientsController < Renalware::MDMPatientsController
      def index
        render_index(query: MDMPatientsQuery.new(q: params[:q]),
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_hd_mdm_path(patient) })
      end
    end
  end
end
