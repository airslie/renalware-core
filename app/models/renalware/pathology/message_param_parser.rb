require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MessageParamParser
      def parse(message_payload)
        {
          observation_request: {
            requestor_name: message_payload.observation_request.ordering_provider,
            pcs_code: message_payload.observation_request.placer_order_number,
            observed_at: Time.parse(message_payload.observation_request.observation_date_time).to_s
          }
        }
      end
    end
  end
end
