require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients
      before_filter :load_users_and_clinics, only: :index

      def index
        request_forms = RequestFormPresenter.wrap(
          @patients, @clinic, @user, params.slice(:telephone)
        )

        render :index, locals: {
          request_forms: request_forms,
          user: @user,
          clinic: @clinic,
          telephone: request_forms.first.telephone,
          users: @users,
          clinics: @clinics,
          patient_ids: @patients.map(&:id)
        }
      end

      private

      def load_users_and_clinics
        @users = User.ordered
        @clinics = Clinics::Clinic.ordered

        @user =
          if params[:user_id].present?
            User.find(params[:user_id])
          else
            @users.first
          end

        @clinic =
          if params[:clinic_id].present?
            @clinic = Clinics::Clinic.find(params[:clinic_id])
          else
            @clinics.first
          end
      end

      def load_patients
        @patients = Pathology::Patient.find(params[:patient_ids])
        authorize Renalware::Patient
      end
    end
  end
end
