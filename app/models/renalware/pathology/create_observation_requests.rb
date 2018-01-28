require_dependency "renalware/pathology"

#
# Create pathology observations requests and their child observations for an existing
# patient from HL7 message content.
#
module Renalware
  module Pathology
    class CreateObservationRequests
      def call(params)
        Array(params).each do |request|
          patient = find_patient(request.fetch(:patient_id))
          observation_params = request.fetch(:observation_request)
          patient.observation_requests.create!(observation_params)
        end
      end

      private

      def find_patient(id)
        ::Renalware::Pathology::Patient.find_by(id: id) || NullObject.instance
      end
    end
  end
end
