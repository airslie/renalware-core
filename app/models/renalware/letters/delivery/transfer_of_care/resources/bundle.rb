# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    # The top-level 'message' Bundle that will contain
    # - the message header
    # - the organisation, becuase it is referenced in the MessageHeader
    # - the document bundle with the main payload in.
    class Resources::Bundle
      include Concerns::Construction
      include Concerns::Helpers

      PROFILE_URL = "https://fhir.nhs.uk/STU3/StructureDefinition/ITK-Message-Bundle-1"

      def call
        FHIR::STU3::Bundle.new(
          type: "message",
          id: arguments.transmission_uuid,
          meta: {
            lastUpdated: letter.updated_at.to_datetime, # Or message.created_at?
            profile: PROFILE_URL
          },
          identifier: system_identifier(arguments.transmission_uuid),
          entry: [
            Resources::MessageHeader.call(arguments),
            Resources::Organisation.call(arguments),
            Resources::DocumentBundle.call(arguments) # Nested document Bundle
          ]
        )
      end
    end
  end
end
