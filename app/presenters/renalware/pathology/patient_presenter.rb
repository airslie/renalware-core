require "renalware/hd"

module Renalware
  module Pathology
    class PatientPresenter < SimpleDelegator
      delegate :hgb_result,
               :hgb_observed_at,
               to: :current_key_observation_set

      def initialize(patient)
        patient = patient.__getobj__ if patient.respond_to?(:__getobj__)
        super(Pathology.cast_patient(patient))
      end
    end
  end
end
