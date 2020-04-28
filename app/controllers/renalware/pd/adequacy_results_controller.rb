# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class AdequacyResultsController < BaseController
      def new
        adequacy = AdequacyResult.new(patient: patient, performed_on: Date.current)
        authorize adequacy
        render locals: { adequacy: adequacy }
      end

      def create
        adequacy = AdequacyResult.new(result_params)
        authorize adequacy

        if adequacy.save_by(current_user)
          redirect_to patient_pd_dashboard_path(patient), notice: success_msg_for("Adequacy result")
        else
          render :new, locals: { adequacy: adequacy }
        end
      end

      def edit
        render locals: { pet: find_authorize_result }
      end

      def update
        result = find_authorize_result
        if result.update_by(current_user, result_params)
          redirect_to patient_pd_dashboard_path(patient), notice: success_msg_for("Result")
        else
          render_edit(result)
        end
      end

      private

      def find_authorize_result
        PD::AdequacyResult.for_patient(patient).find(params[:id]).tap do |adequacy|
          authorize adequacy
        end
      end

      def render_edit(adequacy)
        render :edit, locals: { adequacy: adequacy }
      end

      def result_params
        params
          .require(:pd_adequacy_result)
          .permit(
            :patient_id,
            :performed_on,
            :dial_24_vol_in,
            :dial_24_vol_out,
            :dial_24_missing,
            :urine_24_vol,
            :urine_24_missing
          )
      end
    end
  end
end
