module Renalware
  module Accesses
    class ProceduresController < Accesses::BaseController
      before_filter :load_patient
      before_filter :load_bookmark

      def show
        procedure = @patient.procedures.find(params[:id])
        @procedure = ProcedurePresenter.new(procedure)
      end

      def new
        @procedure = @patient.procedures.new(by: current_user)
      end

      def create
        @procedure = @patient.procedures.new(procedure_params)

        if @procedure.save
          redirect_to patient_accesses_dashboard_path(@patient),
            notice: t(".success", model_name: "Access procedure")
        else
          flash[:error] = t(".failed", model_name: "Access procedure")
          render :new
        end
      end

      def edit
        @procedure = @patient.procedures.find(params[:id])
      end

      def update
        @procedure = @patient.procedures.find(params[:id])

        if @procedure.update(procedure_params)
          redirect_to patient_accesses_dashboard_path(@patient),
            notice: t(".success", model_name: "Access procedure")
        else
          flash[:error] = t(".failed", model_name: "Access procedure")
          render :edit
        end
      end

      protected

      def procedure_params
        params
          .require(:accesses_procedure)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :performed_on, :first_used_on, :failed_on,
          :site_id, :side, :type_id,
          :catheter_make, :catheter_lot_no,
          :performed_by_id, :notes, :outcome
        ]
      end
    end
  end
end
