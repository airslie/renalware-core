module Renalware
  module Clinics
    class AppointmentsController < BaseController
      include Renalware::Concerns::Pageable

      before_action :prepare_paging, only: [:index]

      def index
        appointments_finder = FindAppointmentsQuery.new(params[:q], @page, @per_page)

        authorize appointments_finder.appointments

        render :index, locals: {
          appointments: appointments_finder.appointments,
          query: appointments_finder.query,
          clinics: Renalware::Clinics::Clinic.ordered,
          users: Renalware::User.ordered
        }
      end
    end
  end
end
