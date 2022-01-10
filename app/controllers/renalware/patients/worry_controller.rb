# frozen_string_literal: true

module Renalware
  module Patients
    class WorryController < BaseController
      before_action :load_patient, only: :create

      # idempotent
      def create
        worry = Worry.find_or_create_by!(patient: patient) do |wor|
          wor.by = user
        end
        worry.update(worry_params.merge!(by: current_user))
        redirect_back(fallback_location: patient_path(patient),
                      notice: t(".success", patient: patient))
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
                      notice: t(".success", patient: patient))
      end

      private

      def user
        @user ||= Renalware::Patients.cast_user(current_user)
      end

      def worry_params
        params.require(:patients_worry).permit(:notes, :worry_category_id)
      end
    end
  end
end
