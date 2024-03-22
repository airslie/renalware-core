# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      # FHIR resource representing a Renalware site/hospital
      class Resources::Organisation
        include Support::Construction
        include Support::Helpers

        def call
          {
            fullUrl: arguments.organisation_urn,
            resource: FHIR::STU3::Organization.new(
              id: arguments.organisation_uuid,
              meta: {
                profile: "https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Organization-1"
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

        def prescription
          @prescription = options.delete(:prescription)
        end
      end
    end
  end
end
