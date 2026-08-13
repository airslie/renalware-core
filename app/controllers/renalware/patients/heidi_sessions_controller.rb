module Renalware
  module Patients
    class HeidiSessionsController < BaseController
      include Renalware::Concerns::PatientVisibility

      def create
        authorize %i(renalware lab), :show?
        authorize patient

        result = Renalware::Heidi::Client.new.create_session_for_patient(current_user, patient)
        if result.success? && result.body["session_id"].present?
          create_heidi_session!(result)
          redirect_to launch_url_for(result.body["session_id"]), allow_other_host: true
        else
          redirect_to_launch_failure(heidi_error(result))
        end
      end

      private

      def launch_url_for(session_id)
        Renalware::Heidi::Client.launch_url_for(session_id)
      end

      def create_heidi_session!(result)
        Renalware::Heidi::Session.create!(
          patient:,
          user: current_user,
          heidi_session_id: result.body["session_id"],
          heidi_patient_profile_id: result.body["patient_profile_id"]
        )
      end

      def redirect_to_launch_failure(error)
        redirect_to patient_lab_path(patient),
                    alert: t(".failed", error: error.presence || default_launch_error)
      end

      def default_launch_error
        "Heidi session could not be launched"
      end

      def heidi_error(result)
        result.error.presence || "Heidi did not return a session ID"
      end
    end
  end
end
