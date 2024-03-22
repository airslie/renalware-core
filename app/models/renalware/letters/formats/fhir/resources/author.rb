# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      #
      # FHIR resource representing a Clinics::CinicVisit associated with a Letters::Letter
      #
      class Resources::Author
        include Support::Construction
        include Support::Helpers

        def call
          {
            fullUrl: arguments.author_urn,
            resource: FHIR::STU3::Practitioner.new(
              id: arguments.author_uuid,
              meta: {
                profile: "https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Practitioner-1"
              },
              identifier: {
                system: "https://fhir.hl7.org.uk/Id/hcpc-number",
                value: "????" # TODO: GPC number?
              },
              name: {
                family: letter.author.family_name,
                given: letter.author.given_name,
                prefix: letter.author.professional_position
              },
              telecom: {
                system: "phone",
                value: "???? ????????",
                use: "work"
              }
            )
          }
        end
      end
    end
  end
end
