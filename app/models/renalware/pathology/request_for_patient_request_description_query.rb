require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestForPatientRequestDescriptionQuery
      def initialize(patient, request_description_id)
        @patient = patient
        @request_description = Renalware::Pathology::RequestDescription.find(request_description_id)
      end

      def call
        @patient
          .observation_requests
          .where(description_id: @request_description.id)
          .order(requested_at: :desc)
          .first
      end
    end
  end
end
