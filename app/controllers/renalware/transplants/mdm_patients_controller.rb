require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class MDMPatientsController < Renalware::MDMPatientsController
      def index
        render_index(query: query,
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_transplants_mdm_path(patient) },
                     patient_presenter_class: Transplants::MDMPatientPresenter)
      end

      private

      def query
        @query ||= MDMPatientsQuery.new(q: q, named_filter: named_filter)
      end

      def named_filter
        params[:named_filter]
      end

      def q
        params[:q]
      end
    end
  end
end
