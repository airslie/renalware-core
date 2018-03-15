# frozen_string_literal: true

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
        create_observation_requests_and_their_child_observations_from(pathology_params)
        #
        # Note: The the current_observation_set for the patient is updated by a trigger here
        #
      end

      private

      def parse_pathology_params(message_payload)
        ObservationRequestsAttributesBuilder.new(message_payload).parse
      end

      def create_observation_requests_and_their_child_observations_from(pathology_params)
        return if pathology_params.nil? # eg patient does not exist
        CreateObservationRequests.new.call(pathology_params)
      end
    end
  end
end
