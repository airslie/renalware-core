module Renalware
  module Transplants
    class DonorOperationsController < BaseController
      before_filter :load_patient

      def show
        @donor_operation = DonorOperation.for_patient(@patient).find(params[:id])
        authorize @donor_operation
      end

      def new
        @donor_operation = DonorOperation.new
        authorize @donor_operation
      end

      def create
        @donor_operation = DonorOperation.new(patient: @patient)
        authorize @donor_operation
        @donor_operation.attributes = operation_params

        if @donor_operation.save
          redirect_to patient_transplants_donor_dashboard_path(@patient)
        else
          render :new
        end
      end

      def edit
        @donor_operation = DonorOperation.for_patient(@patient).find(params[:id])
        authorize @donor_operation
      end

      def update
        @donor_operation = DonorOperation.for_patient(@patient).find(params[:id])
        authorize @donor_operation
        @donor_operation.attributes = operation_params

        if @donor_operation.save
          redirect_to patient_transplants_donor_dashboard_path(@patient)
        else
          render :edit
        end
      end

      protected

      def operation_params
        params.require(:transplants_donor_operation)
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
        params.require(:transplants_donor_operation)
         .fetch(:document, nil).try(:permit!)
      end
    end
  end
end
