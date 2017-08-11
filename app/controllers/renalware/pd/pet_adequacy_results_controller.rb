require_dependency "renalware/pd/base_controller"

module Renalware
  module PD
    class PETAdequacyResultsController < BaseController
      include PresenterHelper
      before_action :load_patient

      def new
        result = patient.pet_adequacy_results.new
        authorize result
        render locals: { pet_adequacy_result: result, patient: patient }
      end

      def create
        result = patient.pet_adequacy_results.new(pet_adequacy_result_params)
        authorize result
        if result.save
          redirect_to patient_pd_dashboard_path(patient), notice: success_msg_for("PET Adequacy")
        else
          flash.now[:error] = failed_msg_for("PET Adequacy")
          render :new, locals: { pet_adequacy_result: result, patient: patient }
        end
      end

      def edit
        render locals: { pet_adequacy_result: pet_adequacy_result, patient: patient }
      end

      def update
        pet_adequacy_result.assign_attributes(pet_adequacy_result_params)
        if pet_adequacy_result.save
          redirect_to patient_pd_dashboard_path(patient), notice: success_msg_for("PET Adequacy")
        else
          flash.now[:error] = failed_msg_for("PET Adequacy")
          render :edit, locals: { pet_adequacy_result: pet_adequacy_result, patient: patient }
        end
      end

      def show
        render locals: { pet_adequacy_result: pet_adequacy_result, patient: patient }
      end

      private

      def pet_adequacy_result
        @pet_adequacy_result ||= begin
          pet_adequacy_result = patient.pet_adequacy_results.find(params[:id])
          authorize pet_adequacy_result
          pet_adequacy_result
        end
      end

      def pet_adequacy_result_params
        params.require(:pet_adequacy)
              .permit(:pet_duration, :pet_type, :pet_date, :pet_net_uf,
                      :dialysate_creat_plasma_ratio, :dialysate_glucose_start,
                      :dialysate_glucose_end, :adequacy_date,
                      :ktv_total, :ktv_dialysate, :ktv_rrf,
                      :crcl_total, :crcl_dialysate, :crcl_rrf,
                      :daily_uf, :daily_urine, :date_rff, :creat_value, :dialysate_effluent_volume,
                      :date_creat_clearance, :date_creat_value,
                      :urine_urea_conc, :urine_creat_conc)
              .merge!(by: current_user)
      end
    end
  end
end
