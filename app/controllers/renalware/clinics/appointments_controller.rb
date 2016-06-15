require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class AppointmentsController < BaseController
      include Renalware::Concerns::Pageable

      before_action :prepare_paging, only: [:index]

      def index
        appointments_query = AppointmentQuery.new(query_params)
        appointments = appointments_query.call.page(@page).per(@per_page)
        patient_ids = appointments.map(&:patient_id)

        authorize appointments

        render :index, locals: {
          appointments: appointments,
          query: appointments_query.search,
          clinics: Clinic.ordered,
          users: User.ordered,
          patient_ids: patient_ids
        }
      end

      private

      def query_params
        params
          .fetch(:q, {})
          .merge(page: @page, per_page: @per_page)
      end
    end
  end
end
