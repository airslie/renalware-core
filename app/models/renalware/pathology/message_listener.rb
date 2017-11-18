require_dependency "renalware/pathology"

#
# When subscribed to HL7 `message_processed` messages, gets notified of incoming HL7 messages
# and creates the observations contained therein provided the patient exists.
#
module Renalware
  module Pathology
    class MessageListener
      def message_processed(message_payload)
        pathology_params = parse_pathology_params(message_payload)
        create_observations(pathology_params)
      end

      private

      def parse_pathology_params(message_payload)
        MessageParamParser.new.parse(message_payload)
      end

      def create_observations(params)
        CreateObservations.new.call(params)
      end
    end
  end
end
