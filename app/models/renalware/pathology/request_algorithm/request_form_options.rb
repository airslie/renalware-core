require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class RequestFormOptions
        attr_reader :telephone, :patient_ids

        def initialize(params)
          @requested_user = params[:user]
          @requested_clinic = params[:clinic]
          @telephone  = params[:telephone] || user.telephone
          @patient_ids = params[:patients].map(&:id)
        end

        def user_id
          user.id
        end

        def user
          @user ||= find_user
        end

        def clinic_id
          clinic.id
        end

        def clinic
          @clinic ||= find_clinic
        end

        def all_users
          @all_users ||= User.ordered
        end

        def all_clinics
          @all_clinics ||= Clinics::Clinic.ordered
        end

        private

        def find_user
          if @requested_user.present?
            @requested_user
          else
            default_user
          end
        end

        def find_clinic
          if @requested_clinic.present?
            @requested_clinic
          else
            default_clinic
          end
        end

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
