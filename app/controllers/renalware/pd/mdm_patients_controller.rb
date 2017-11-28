require "renalware/pd"

module Renalware
  module PD
    class MDMPatientsController < Renalware::MDMPatientsController
      def index
        render_index(query: MDMPatientsQuery.new(q: params[:q]),
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_pd_mdm_path(patient) })
      end
    end
  end
end
