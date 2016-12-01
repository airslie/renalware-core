require_dependency "renalware/hd/base_controller"

module Renalware
  module PD
    class RegimesController < BaseController
      include Renalware::Concerns::NestedActionsControllerMethods

      before_action :load_patient

      def new
        regime_type = params[:type] ? "Renalware::#{params[:type]}" : nil
        pd_regime = patient.pd_regimes.new(type: regime_type)
        render :new, locals: {
          pd_regime: pd_regime,
          patient: patient
        }
      end

      def create
        result = CreateRegime.new(patient: patient)
                             .call(by: current_user, params: pd_regime_params)

        if result.success?
          redirect_to patient_pd_dashboard_path(patient), notice: success_msg_for("PD regime")
        else
          flash[:error] = failed_msg_for("PD Regime")
          render :new, locals: {
            pd_regime: result.object,
            patient: patient
          }
        end
      end

      def edit
        render :edit, locals: {
          pd_regime: pd_regime,
          patient: patient
        }
      end

      def update
        result = ReviseRegime.new(pd_regime).call(by: current_user, params: pd_regime_params)

        if result.success?
          redirect_to patient_pd_dashboard_path(patient),
            notice: t(".success", model_name: "PD regime")
        else
          flash[:error] = t(".failed", model_name: "PD regime")
          render :edit, locals: {
            pd_regime: result.object,
            patient: patient
          }
        end
      end

      def show
        render :show, locals: {
          pd_regime: pd_regime,
          patient: patient
        }
      end

      private

      def pd_regime_params
        params.require(:pd_regime).permit(
          :start_date, :end_date, :treatment, :type, :add_hd, :last_fill_volume,
          :tidal_indicator, :tidal_percentage, :no_cycles_per_apd,
          :overnight_pd_volume, :apd_machine_pac, :therapy_time, :fill_volume, :delivery_interval,
          :system_id, :last_fill_volume, :additional_manual_exchange_volume,
          bags_attributes: [
            :id, :regime_id, :bag_type_id, :volume, :role, :per_week, :monday, :tuesday,
            :wednesday, :thursday, :friday, :saturday, :sunday, :_destroy]
        )
      end

      def pd_regime
        @pd_regime ||= begin
          regime = Regime.find(params[:id])
          authorize regime
          regime
        end
      end
    end
  end
end
