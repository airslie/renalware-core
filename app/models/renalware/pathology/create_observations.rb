require_dependency "renalware/pathology"

#
# Create pathology observations for an existing patient from HL7 message content.
#
module Renalware
  module Pathology
    class CreateObservations
      def call(params)
        patient = find_patient(params.fetch(:patient_id))
        observation_params = params.fetch(:observation_request)
        patient.observation_requests.create!(observation_params)
      end

      private

      def find_patient(id)
        ::Renalware::Pathology::Patient.find_by(id: id) || NullObject.instance
      end
    end
  end
end
