# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Resources::Practitioner
      include Concerns::Construction
      include Concerns::Helpers

      def call
        {
          fullUrl: arguments.author_urn,
          resource: FHIR::STU3::Practitioner.new(
            id: arguments.author_uuid,
            meta: {
              profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-Header-Practitioner-1"
            }
          )
        }
      end
    end
  end
end
