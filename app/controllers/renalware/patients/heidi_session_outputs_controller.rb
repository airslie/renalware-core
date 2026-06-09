module Renalware
  module Patients
    class HeidiSessionOutputsController < BaseController
      include Renalware::Concerns::PatientVisibility

      def create
        authorize %i(renalware lab), :show?
        authorize patient

        heidi_session = patient_heidi_sessions.find(params[:heidi_session_id])
        Renalware::Heidi::GenerateOutputs.new(
          session: heidi_session,
          document_template_id: params[:document_template_id]
        ).call

        redirect_to patient_lab_path(patient), notice: t(".success")
      end

      private

      def patient_heidi_sessions
        Renalware::Heidi::Session.where(patient:)
      end
    end
  end
end
