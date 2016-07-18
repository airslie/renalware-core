module Renalware
  class PDDashboardsController < BaseController

    skip_after_action :verify_authorized

    def show
      @patient = Patient.find(params[:patient_id])
      @current_regime = @patient.pd_regimes.current if @patient.pd_regimes.any?
      @capd_regimes = CAPDRegime.for_patient(@patient).ordered
      @apd_regimes = APDRegime.for_patient(@patient).ordered
      @peritonitis_episodes = PeritonitisEpisode.for_patient(@patient)
      @exit_site_infections = ExitSiteInfection.for_patient(@patient)
    end
  end
end
