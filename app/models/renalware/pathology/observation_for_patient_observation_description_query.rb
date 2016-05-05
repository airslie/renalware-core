require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationForPatientObservationDescriptionQuery
      def initialize(patient, observation_description_id)
        @patient = patient
        @observation_description_id = observation_description_id
      end

      def call
        @patient
          .observations
          .where(description_id: @observation_description_id)
          .order(observed_at: :desc)
          .first
      end
    end
  end
end
