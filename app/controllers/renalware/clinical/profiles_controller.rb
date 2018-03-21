# frozen_string_literal: true

require_dependency "renalware/clinical"

module Renalware
  module Clinical
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
                      notice: t(".success", model_name: "clinical history")
        else
          render :edit, locals: { patient: patient }
        end
      end

      private

      def update_patient
        document = patient.document
        document.diabetes = profile_params[:diabetes].symbolize_keys
        document.history = profile_params[:history].symbolize_keys
        patient.by = current_user
        patient.save!
      end

      def profile_params
        params
          .require(:clinical_profile)
          .permit(diabetes: %i(diagnosis diagnosed_on), history: %i(alcohol smoking))
          .to_h
      end
    end
  end
end
