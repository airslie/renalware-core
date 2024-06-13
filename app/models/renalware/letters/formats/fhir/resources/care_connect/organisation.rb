# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      # FHIR resource representing a Renalware site/hospital, profiled to CareConnect-Organization-1
      class Resources::CareConnect::Organisation
        include Support::Construction
        include Support::Helpers

        PROFILE = "https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Organization-1"

        def call
          {
            fullUrl: arguments.organisation_urn,
            resource: FHIR::STU3::Organization.new(
              id: arguments.organisation_uuid,
              meta: {
                profile: PROFILE
              },
              identifier: {
                system: "https://fhir.nhs.uk/Id/ods-organization-code",
                value: arguments.organisation_ods_code
              },
              telecom: [
                {
                  system: "phone",
                  value: "01234 567890", # TODO: ?
                  use: "work"
                },
                {
                  system: "email",
                  value: "cndd@adobehc.nhs.uk"
                },
                {
                  address: {
                    line: "TODO",
                    city: "TODO",
                    postalCode: "TODO"
                  }
                }
              ]
            )
          }
        end
      end
    end
  end
end
