require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CreateObservations
      def call(params)
        ObservationRequest.create!(params[:observation_request])
      end
    end
  end
end
