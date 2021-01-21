# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class RecipientOperationsController < BaseController
      def show
        render locals: {
          patient: patient,
          recipient_operation: operation
        }
      end

      def new
        operation = RecipientOperation.new
        authorize operation
        render locals: {
          patient: patient,
          recipient_operation: operation
        }
      end

      def create
        recipient_operation = RecipientOperation.new(patient: patient)
        recipient_operation.attributes = operation_params
        authorize recipient_operation

        if recipient_operation.save
          redirect_to patient_transplants_recipient_dashboard_path(patient),
                      notice: t(".success", model_name: "recipient operation")
        else
          flash.now[:error] = t(".failed", model_name: "recipient operation")
          render :new,
                 locals: {
                   patient: patient,
                   recipient_operation: recipient_operation
                 }
        end
      end

      def edit
        render locals: {
          patient: patient,
          recipient_operation: operation
        }
      end

      def update
        operation.attributes = operation_params

        if operation.save
          redirect_to patient_transplants_recipient_dashboard_path(patient),
                      notice: t(".success", model_name: "recipient operation")
        else
          flash.now[:error] = t(".failed", model_name: "recipient operation")
          render :edit, locals: { patient: patient, recipient_operation: operation }
        end
      end

      protected

      def operation
        @operation ||= begin
          RecipientOperation.for_patient(patient).find(params[:id]).tap do |op|
            authorize op
          end
        end
      end

      def operation_params
        params
          .require(:transplants_recipient_operation)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :performed_on, :theatre_case_start_time,
          :donor_kidney_removed_from_ice_at, :kidney_perfused_with_blood_at,
          :operation_type, :hospital_centre_id,
          :cold_ischaemic_time_formatted, :warm_ischaemic_time_formatted, :notes,
          :transplant_failed, :failed_on, :failure_cause, :failure_description, :stent_removed_on,
          document: []
        ]
      end

      def document_attributes
        params
          .require(:transplants_recipient_operation)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
