# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class RecipientWorkupsController < BaseController
      def show
        workup = RecipientWorkup.for_patient(patient).first_or_initialize
        authorize workup

        if workup.new_record?
          redirect_to edit_patient_transplants_recipient_workup_path(patient)
        else
          render locals: { patient: patient, workup: workup }
        end
      end

      def edit
        workup = RecipientWorkup.for_patient(patient).first_or_initialize
        authorize workup
        workup = RecipientWorkupBuilder.new(
          workup: workup,
          default_consenter_name: current_user.to_s
        ).build
        render locals: { patient: patient, workup: workup }
      end

      def update
        workup = RecipientWorkup.for_patient(patient).first_or_initialize
        authorize workup

        if workup.update workup_params
          redirect_to patient_transplants_recipient_workup_path(patient),
                      notice: t(".success", model_name: "recipient work up")
        else
          flash.now[:error] = t(".failed", model_name: "recipient work up")
          render :edit, locals: { patient: patient, workup: workup }
        end
      end

      private

      def workup_params
        params
          .require(:transplants_recipient_workup)
          .permit
          .merge(document: document_attributes, by: current_user)
      end

      def document_attributes
        params
          .require(:transplants_recipient_workup)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
