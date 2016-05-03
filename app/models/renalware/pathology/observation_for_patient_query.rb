require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationForPatientQuery
      def initialize(patient, observation_description_id)
        @patient = Renalware::Pathology.cast_patient(patient)
        @observation_description_id = observation_description_id
      end

      def call
        @patient
          .observations
          .where(description_id: @observation_description_id)
          .order(observed_at: :desc)
          .limit(1)
          .first
      end
    end
  end
end
