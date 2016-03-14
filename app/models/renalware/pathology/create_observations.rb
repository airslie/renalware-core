require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CreateObservations
      def call(params)
        observation_params = params.fetch(:observation_request)

        ObservationRequest.create!(observation_params)
      end
    end
  end
end
