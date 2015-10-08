module Renalware
  class PdSummariesController < BaseController
    skip_authorize_resource only: :show

    def show
      @patient = Patient.find(params[:patient_id])

      @current_regime = @patient.pd_regimes.current if @patient.pd_regimes.any?
      @capd_regimes = CapdRegime.where(patient_id: @patient).ordered
      @apd_regimes = ApdRegime.where(patient_id: @patient).ordered

      @peritonitis_episodes = PeritonitisEpisode.where(patient_id: @patient)
      @exit_site_infections = ExitSiteInfection.where(patient_id: @patient)
    end
  end
end
