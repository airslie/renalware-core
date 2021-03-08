# frozen_string_literal: true

require_dependency "renalware/clinical"

module Renalware
  module Clinical
    # Note that there is no concrete Clinical::Profile, most data here is persisted in the patient
    class ProfilesController < Clinical::BaseController
      def show
        authorize patient
        render locals: {
          patient: patient,
          profile: Clinical::ProfilePresenter.new(patient: patient, params: params)
        }
      end

      def edit
        authorize patient
        render locals: { patient: patient }
      end

      def update
        authorize patient
        if update_patient
          redirect_to patient_clinical_profile_path(patient),
                      notice: success_msg_for("clinical history")
        else
          render :edit, locals: { patient: patient }
        end
      end

      private

      def update_patient
        patient.named_consultant_id = profile_params[:named_consultant_id]
        patient.named_nurse_id = profile_params[:named_nurse_id]
        document = patient.document

        %i(diabetes history).each do |document_attribute|
          document.send(
            :"#{document_attribute}=",
            profile_params[:document][document_attribute].symbolize_keys
          )
        end
        patient.save_by! current_user
      end

      def profile_params
        params
          .require(:clinical_profile)
          .permit(
            :named_consultant_id, :named_nurse_id,
            document: {
              diabetes: %i(diagnosis diagnosed_on),
              history: %i(alcohol smoking)
            }
          ).to_h
      end
    end
  end
end
