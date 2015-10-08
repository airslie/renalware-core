module Renalware
  class PDSummariesController < BaseController
    skip_authorize_resource only: :show

    def show
      @patient = Patient.find(params[:patient_id])

      @current_regime = @patient.pd_regimes.current if @patient.pd_regimes.any?
      @capd_regimes = CapdRegime.for_patient(@patient).ordered
      @apd_regimes = ApdRegime.for_patient(@patient).ordered

      @peritonitis_episodes = PeritonitisEpisode.for_patient(@patient)
      @exit_site_infections = ExitSiteInfection.for_patient(@patient)
    end
  end
end
