require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class RecipientFollowupsController < BaseController
      before_action :load_patient

      def show
        recipient_followup = operation.followup
        render locals: { patient: patient, recipient_followup: recipient_followup }
      end

      def new
        render locals: {
          patient: patient,
          recipient_followup: operation.build_followup
        }
      end

      def create
        recipient_followup = operation.build_followup
        recipient_followup.attributes = followup_attributes

        if recipient_followup.save
          redirect_to patient_transplants_recipient_dashboard_path(patient),
            notice: t(".success", model_name: "recipient follow up")
        else
          flash[:error] = t(".failed", model_name: "recipient follow up")
          render :new, locals: { patient: patient, recipient_followup: recipient_followup }
        end
      end

      def edit
        render locals: {
          patient: patient,
          recipient_followup: operation.followup
        }
      end

      def update
        recipient_followup = operation.followup
        recipient_followup.attributes = followup_attributes

        if recipient_followup.save
          redirect_to patient_transplants_recipient_dashboard_path(patient),
            notice: t(".success", model_name: "recipient follow up")
        else
          flash[:error] = t(".failed", model_name: "recipient follow up")
          render :edit,
                 locals: {
                   patient: patient,
                   recipient_followup: recipient_followup
                 }
        end
      end

      protected

      def operation
        @operation ||= RecipientOperation.find(params[:recipient_operation_id])
      end

      def followup_attributes
        params
          .require(:transplants_recipient_followup)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :notes,
          :stent_removed_on,
          :transplant_failed,
          :transplant_failed_on,
          :transplant_failure_cause_description_id,
          :transplant_failure_cause_other,
          :transplant_failure_notes,
          document: []
        ]
      end

      def document_attributes
        params
          .require(:transplants_recipient_followup)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
