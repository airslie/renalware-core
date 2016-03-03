require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MessageParamParser
      def parse(message_payload)
        {
          observation_request: {
            requestor_name: message_payload.observation_request.ordering_provider,
            pcs_code: message_payload.observation_request.placer_order_number
          }
        }
      end
    end
  end
end
