# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Resources::DocumentBundle
      include Concerns::Construction
      include Concerns::Helpers

      PROFILE_URL = "https://fhir.nhs.uk/STU3/StructureDefinition/ITK-Document-Bundle-1"

      # Testing notes
      # - No CV?
      # - Letter not approved? - should abort?

      # Note that in the Composition, eg allergies sections will include a urn entry.reference to
      # the Allergy List (the first element in the array returned by
      # Factories::Allergies.call(arguments) so in order to inject urn reference into the letter
      # section, we need to assign it to the Argument object so it ca be passed around/down.
      # Its starting to feel like there might be a change eg
      # 1. Fetch and parse all data so urns can be resolved
      # 2. Use builder pattern to build the Arguments, setting each urn all the Arguments obj
      # 3. Build the xml, passing in the arguments
      #
      def call
        {
          fullUrl: arguments.letter_urn,
          resource: FHIR::STU3::Bundle.new(
            type: "document",
            id: arguments.transmission_uuid,
            meta: {
              lastUpdated: letter.updated_at.to_datetime, # Or message.created_at?
              profile: PROFILE_URL
            },
            identifier: system_identifier(arguments.transmission_uuid),
            entry: [
              letter_html_content_split_into_sections,
              # *Factories::Allergies.call(arguments),
              # *Factories::Medications.call(arguments),
              # *Factories::Conditions.call(arguments),
              Resources::Patient.call(arguments),
              clinic_visit_details,
              Resources::Author.call(arguments),
              Resources::Organisation.call(arguments)
            ]
          )
        }
      end

      private

      def letter_html_content_split_into_sections
        Resources::Composition.call(arguments)
      end

      # The letter may have resulted from a clinic visit in which case this becomes the FHIR
      # Encounter resource in our message
      def clinic_visit_details
        Resources::Encounter.call(arguments)
      end
    end
  end
end
