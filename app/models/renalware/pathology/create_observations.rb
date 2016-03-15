require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CreateObservations
      def call(params)
        observation_params = params.fetch(:observation_request)
        patient = fetch_patient(params.fetch(:patient_id))

        patient.observation_requests.create!(observation_params)
      end

      private

      def fetch_patient(id)
        ::Renalware::Pathology::Patient.find(id)
      end
    end
  end
end
