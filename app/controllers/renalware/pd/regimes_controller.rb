# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module PD
    class RegimesController < BaseController
      include Renalware::Concerns::Pageable
      skip_after_action :verify_policy_scoped

      def index
        regimes = regime_type_class.for_patient(patient).with_bags.ordered.page(page).per(per_page)
        authorize(Regime, :index?)
        render locals: {
          patient: patient,
          regimes: regimes,
          pd_type_string: pd_type_string
        }
      end

      def capd_regimes
        @capd_regimes ||= CAPDRegime.for_patient(patient).with_bags.ordered.page(1).per(5)
      end

      def apd_regimes
        @apd_regimes ||= APDRegime.for_patient(patient).with_bags.ordered.page(1).per(5)
      end

      def new
        regime = cloned_last_known_regime_of_type || patient.pd_regimes.new(type: regime_type)
        authorize regime

        render :new, locals: {
          regime: regime,
          patient: patient
        }
      end

      def create
        authorize(Regime, :create?)
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

      def edit
        render :edit, locals: {
          regime: pd_regime,
          patient: patient
        }
      end

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

      def regime_type_class
        @regime_type_class ||= regime_type.constantize
      end

      def pd_type_string
        regime_type_class.new.pd_type.upcase # CAPD or APD
      end

      def cloned_last_known_regime_of_type
        regime = patient.pd_regimes
                        .order(start_date: :desc, created_at: :desc)
                        .where(type: regime_type).first
        regime&.start_date = Time.zone.today
        regime&.deep_dup
      end

      def pd_regime_params
        params.require(:pd_regime).permit(
          :start_date, :end_date, :treatment, :assistance_type, :type,
          :add_hd, :tidal_full_drain_every_three_cycles,
          :tidal_indicator, :tidal_percentage, :no_cycles_per_apd,
          :apd_machine_pac, :dwell_time, :therapy_time, :fill_volume, :delivery_interval,
          :system_id, :last_fill_volume, :additional_manual_exchange_volume,
          :exchanges_done_by, :exchanges_done_by_if_other, :exchanges_done_by_notes,
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
