module Renalware
  module Clinics
    class AppointmentsController < BaseController
      include Renalware::Concerns::Pageable

      before_action :prepare_paging, only: [:index]

      def index
        appointments_finder = FindAppointmentsQuery.new(query_params)

        authorize appointments_finder.appointments

        render :index, locals: {
          appointments: appointments_finder.appointments,
          query: appointments_finder.query,
          clinics: Renalware::Clinics::Clinic.ordered,
          users: Renalware::User.ordered
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
