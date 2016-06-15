require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class RequestFormOptions
        attr_reader :telephone, :patient_ids

        def initialize(params)
          @params = params
          # TODO: Add a telephone number on the users table and make this the default option
          @telephone  = params[:telephone]
          @patient_ids = params[:patient_ids]
        end

        def user_id
          user.id
        end

        def user
          @user ||=
            if @params[:user_id].present?
              User.find(@params[:user_id])
            else
              default_user
            end
        end

        def clinic_id
          clinic.id
        end

        def clinic
          @clinic =
            if @params[:clinic_id].present?
              Clinics::Clinic.find(@params[:clinic_id])
            else
              default_clinic
            end
        end

        def all_users
          @all_users ||= User.ordered
        end

        def all_clinics
          @all_clinics ||= Clinics::Clinic.ordered
        end

        private

        def default_user
          all_users.first
        end

        def default_clinic
          all_clinics.first
        end
      end
    end
  end
end
