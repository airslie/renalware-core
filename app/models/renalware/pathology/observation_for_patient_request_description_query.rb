require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationForPatientRequestDescriptionQuery
      def initialize(patient, request_description)
        @patient = patient
        request_description = RequestDescription.find(request_description.id)
        @observation_description_id = request_description.required_observation_description_id
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
