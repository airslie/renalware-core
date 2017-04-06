require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonorStagesController < BaseController

      def new
        status = DonorStage.new(patient: patient)
        authorize status
        render locals: {
          patient: patient,
          status: status
        }
      end

      def create
        authorize donor_stage
        result = CreateDonorStage.new(patient: patient, options: donor_stage_params).call
        if result.success?
          redirect_to patient_transplants_donor_dashboard_path(patient),
                      notice: t(".success", model_name: "donor stage")
        else
          render :new, locals: {
            patient: patient,
            status: result.object
          }
        end
      end

      private

      def donor_stage
        @donor_stage ||= DonorStage.for_patient(patient).first_or_initialize
      end

      def donor_stage_params
        params
          .require(:donor_stage)
          .permit(:started_on, :donor_stage_position_id, :donor_stage_status_id, :notes)
          .to_h
          .merge(by: current_user)
      end
    end
  end
end
