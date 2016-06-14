module Renalware
  module Clinics
    class AppointmentsController < BaseController
      include Renalware::Concerns::Pageable

      before_action :prepare_paging, only: [:index]

      def index
        @query = Renalware::Clinics::Appointment.ransack(params[:q])
        @query.sorts = "starts_at asc" if @query.sorts.empty?
        @appointments = @query.result.includes(:user, :patient, :clinic)
          .page(@page).per(@per_page)

        @clinics = Renalware::Clinics::Clinic.all
        @users = Renalware::User.all.order(family_name: :asc)

        authorize @appointments
      end
    end
  end
end
