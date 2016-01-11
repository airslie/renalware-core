module Renalware
  module Transplants
    class RecipientOperationsController < BaseController
      before_filter :load_patient

      def show
        @recipient_operation = RecipientOperation.for_patient(@patient).find(params[:id])
      end

      def new
        @recipient_operation = RecipientOperation.new
      end

      def create
        @recipient_operation = RecipientOperation.new(patient: @patient)
        @recipient_operation.attributes = operation_params

        if @recipient_operation.save
          redirect_to patient_transplants_recipient_dashboard_path(@patient)
        else
          render :new
        end
      end

      def edit
        @recipient_operation = RecipientOperation.for_patient(@patient).find(params[:id])
      end

      def update
        @recipient_operation = RecipientOperation.for_patient(@patient).find(params[:id])
        @recipient_operation.attributes = operation_params

        if @recipient_operation.save
          redirect_to patient_transplants_recipient_dashboard_path(@patient)
        else
          render :edit
        end
      end

      protected

      def operation_params
        params.require(:transplants_recipient_operation)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :performed_on, :theatre_case_start_time,
          :donor_kidney_removed_from_ice_at, :kidney_perfused_with_blood_at,
          :operation_type, :transplant_site,
          :cold_ischaemic_time_formatted, :warm_ischaemic_time_formatted, :notes,
          :transplant_failed, :failed_on, :failure_cause, :failure_description, :stent_removed_on,
          document: []
        ]
      end

      def document_attributes
        params.require(:transplants_recipient_operation)
         .fetch(:document, nil).try(:permit!)
      end
    end
  end
end
