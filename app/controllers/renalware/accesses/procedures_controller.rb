module Renalware
  module Accesses
    class ProceduresController < Accesses::BaseController
      before_action :load_patient

      def show
        procedure = patient.procedures.find(params[:id])
        presenter = ProcedurePresenter.new(procedure)
        render locals: { patient: patient, procedure: presenter }
      end

      def new
        procedure = patient.procedures.new(by: current_user)
        render locals: { patient: patient, procedure: procedure }
      end

      def create
        procedure = patient.procedures.new(procedure_params)

        if procedure.save
          redirect_to patient_accesses_dashboard_path(patient),
            notice: t(".success", model_name: "Access procedure")
        else
          flash[:error] = t(".failed", model_name: "Access procedure")
          render :new, locals: { patient: patient, procedure: procedure }
        end
      end

      def edit
        procedure = find_procedure
        render locals: { patient: patient, procedure: procedure }
      end

      def update
        procedure = find_procedure

        if procedure.update(procedure_params)
          redirect_to patient_accesses_dashboard_path(patient),
                      notice: success_msg_for("access procedure")
        else
          flash[:error] = failed_msg_for("access procedure")
          render :edit, locals: { patient: patient, procedure: procedure }
        end
      end

      protected

      def find_procedure
        patient.procedures.find(params[:id])
      end

      def procedure_params
        params
          .require(:accesses_procedure)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :performed_on, :first_used_on, :failed_on,
          :side, :type_id,
          :catheter_make, :catheter_lot_no,
          :performed_by, :notes, :outcome,
          :pd_catheter_insertion_technique_id
        ]
      end
    end
  end
end
