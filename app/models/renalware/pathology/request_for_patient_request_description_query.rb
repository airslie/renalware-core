require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestForPatientRequestDescriptionQuery
      def initialize(patient, request_description)
        @patient = patient
        @request_description = Renalware::Pathology::RequestDescription.find(request_description.id)
      end

      def call
        @patient
          .requests
          .joins(:request_descriptions)
          .where(
            pathology_request_descriptions_requests_requests: {
              request_description_id: @request_description.id
            }
          )
          .order(created_at: :desc)
          .first
      end
    end
  end
end
