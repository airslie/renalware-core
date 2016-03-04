require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MessageParamParser
      def parse(message_payload)
        request = message_payload.observation_request

        observations_params = build_observations_params(request.observations)
        build_observation_request_params(request, observations_params)
      end

      private

      def build_observation_request_params(request, observations_params)
        {
          observation_request: {
            requestor_name: request.ordering_provider,
            pcs_code: request.placer_order_number,
            observed_at: Time.parse(request.date_time).to_s,
            observations_attributes: observations_params
          }
        }
      end

      def build_observations_params(observations)
        observations.map do |observation|
          {
            observed_at: Time.parse(observation.date_time).to_s,
            result: observation.value,
            comment: observation.comment
          }
        end
      end
    end
  end
end
