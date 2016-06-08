require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationForPatientRequestDescriptionQuery
      def initialize(patient, request_description)
        @patient = patient
        @observation_description = request_description.required_observation_description
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
