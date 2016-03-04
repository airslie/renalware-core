require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MessageParamParser
      def parse(message_payload)
        params = {
          observation_request: {
            requestor_name: message_payload.observation_request.ordering_provider,
            pcs_code: message_payload.observation_request.placer_order_number,
            observed_at: Time.parse(message_payload.observation_request.date_time).to_s,
            observation_attributes: []
          }
        }

        message_payload.observation_request.observations.each do |observation|
          params[:observation_request][:observation_attributes] << {
            observed_at: Time.parse(observation.date_time).to_s,
            value: observation.value,
            comment: observation.comment
          }
        end

        params
      end
    end
  end
end
