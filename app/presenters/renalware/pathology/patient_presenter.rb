require "renalware/hd"

module Renalware
  module Pathology
    class PatientPresenter < SimpleDelegator
      delegate :hgb_result,
               :hgb_observed_at,
               to: :current_key_observation_set

      def initialize(patient)
        super(Pathology.cast_patient(patient.__getobj__))
      end
    end
  end
end
