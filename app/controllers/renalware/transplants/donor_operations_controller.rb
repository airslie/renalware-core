# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonorOperationsController < BaseController
      before_action :load_patient

      def show
        operation = DonorOperation.for_patient(patient).find(params[:id])
        render locals: { operation: operation, patient: patient }
      end

      def new
        render locals: { operation: DonorOperation.new, patient: patient }
      end

      def create
        operation = DonorOperation.new(patient: patient)
        operation.attributes = operation_params

        if operation.save
          redirect_to patient_transplants_donor_dashboard_path(patient),
            notice: t(".success", model_name: "donor operation")
        else
          flash.now[:error] = t(".failed", model_name: "donor operation")
          render :new, locals: { operation: operation, patient: patient }
        end
      end

      def edit
        operation = DonorOperation.for_patient(patient).find(params[:id])
        render locals: { operation: operation, patient: patient }
      end

      def update
        operation = DonorOperation.for_patient(patient).find(params[:id])
        operation.attributes = operation_params

        if operation.save
          redirect_to patient_transplants_donor_dashboard_path(patient),
            notice: t(".success", model_name: "donor operation")
        else
          flash.now[:error] = t(".failed", model_name: "donor operation")
          render :edit, locals: { operation: operation, patient: patient }
        end
      end

      protected

      def operation_params
        params
          .require(:transplants_donor_operation)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :performed_on, :notes,
          :anaesthetist, :donor_splenectomy_peri_or_post_operatively, :kidney_side,
          :nephrectomy_type, :nephrectomy_type_other, :operating_surgeon,
          document: []
        ]
      end

      def document_attributes
        params
          .require(:transplants_donor_operation)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
