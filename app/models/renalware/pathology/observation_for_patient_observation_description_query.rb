require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationForPatientObservationDescriptionQuery
      def initialize(patient, observation_description)
        @patient = patient
        @observation_description = observation_description
      end

      def call
        @patient
          .observations
          .where(description: @observation_description)
          .order(observed_at: :desc)
          .first
      end
    end
  end
end
