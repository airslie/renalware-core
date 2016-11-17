require_dependency "renalware/pd"

module Renalware
  module PD
    class DashboardsController < BaseController

      skip_after_action :verify_authorized

      def show
        @patient = Patient.find(params[:patient_id])
        current_regime = patient.pd_regimes.current if @patient.pd_regimes.any?

        render :show, locals: {
          patient: patient,
          dashboard: DashboardPresenter.new(patient)
        }
      end
    end
  end
end
