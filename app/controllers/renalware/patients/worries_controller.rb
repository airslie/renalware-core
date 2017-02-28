module Renalware
  module Patients
    class WorriesController < BaseController
      before_action :load_patient, only: :create

      # idempotent
      def create
        Worry.find_or_create_by!(patient: patient) do |worry|
          worry.by = user
        end
        redirect_back(fallback_location: patient_path(patient),
                      notice: t(".success", model_name: "worry"))
      end

      # idempotent
      def destroy
        if (worry = patient.worry)
          authorize worry
          worry.destroy!
        else
          skip_authorization
        end
        redirect_back(fallback_location: patient_path(patient),
                      notice: t(".success", model_name: "worry"))
      end

      private

      def user
        @user ||= Renalware::Patients.cast_user(current_user)
      end
    end
  end
end
