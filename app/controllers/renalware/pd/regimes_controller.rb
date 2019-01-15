# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module PD
    class RegimesController < BaseController
      before_action :load_patient

      def new
        regime = cloned_last_known_regime_of_type || patient.pd_regimes.new(type: regime_type)

        render :new, locals: {
          regime: regime,
          patient: patient
        }
      end

      # rubocop:disable Metrics/AbcSize
      def create
        result = CreateRegime.new(patient: patient)
                             .call(by: current_user, params: pd_regime_params)

        if result.success?
          redirect_to patient_pd_dashboard_path(patient), notice: success_msg_for("PD regime")
        else
          flash.now[:error] = failed_msg_for("PD Regime")
          render :new, locals: {
            regime: result.object,
            patient: patient
          }
        end
      end
      # rubocop:enable Metrics/AbcSize

      def edit
        render :edit, locals: {
          regime: pd_regime,
          patient: patient
        }
      end

      # rubocop:disable Metrics/AbcSize
      def update
        result = ReviseRegime.new(pd_regime).call(by: current_user, params: pd_regime_params)

        if result.success?
          redirect_to patient_pd_dashboard_path(patient),
            notice: t(".success", model_name: "PD regime")
        else
          flash.now[:error] = t(".failed", model_name: "PD regime")
          render :edit, locals: {
            regime: result.object,
            patient: patient
          }
        end
      end
      # rubocop:enable Metrics/AbcSize

      def show
        render :show, locals: {
          regime: pd_regime,
          patient: patient
        }
      end

      private

      def regime_type
        params[:type] ? "Renalware::#{params[:type]}" : nil
      end

      def cloned_last_known_regime_of_type
        regime = patient.pd_regimes
                        .order(start_date: :desc, created_at: :desc)
                        .where(type: regime_type).first
        regime&.deep_dup
      end

      def pd_regime_params
        params.require(:pd_regime).permit(
          :start_date, :end_date, :treatment, :assistance_type, :type,
          :add_hd, :tidal_full_drain_every_three_cycles,
          :tidal_indicator, :tidal_percentage, :no_cycles_per_apd,
          :apd_machine_pac, :dwell_time, :therapy_time, :fill_volume, :delivery_interval,
          :system_id, :last_fill_volume, :additional_manual_exchange_volume,
          bags_attributes: [
            :id, :regime_id, :bag_type_id, :volume, :role, :capd_overnight_bag, :per_week,
            :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :_destroy
          ]
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
