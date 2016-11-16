require_dependency "collection_presenter"

module Renalware
  module PD
    class DashboardPresenter
      attr_accessor :patient

      def initialize(patient)
        @patient = patient
      end

      def current_regime
        patient.pd_regimes.any? && patient.pd_regimes.current
      end

      def capd_regimes
        @capd_regimes ||= CAPDRegime.for_patient(patient).ordered
      end

      def apd_regimes
        @apd_regimes ||= APDRegime.for_patient(patient).ordered
      end

      def peritonitis_episodes
        @peritonitis_episodes ||= PeritonitisEpisode.for_patient(patient)
      end

      def exit_site_infections
        @exit_site_infections ||= ExitSiteInfection.for_patient(patient)
      end
    end
  end
end
