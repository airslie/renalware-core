# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      # FHIR resource representing a Renalware site/hospital, profiled to CareConnect-Organization-1
      class Resources::Organisation
        include Support::Construction
        include Support::Helpers

        # https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-Header-Organization-1
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
              }
              # CareConnect-ITK-Header-Organization-1 profile does not allow telecom etc??
              # ,telecom: [
              #   {
              #     system: "phone",
              #     value: "01234 567890", # TODO: ?
              #     use: "work"
              #   },
              #   {
              #     system: "email",
              #     value: "cndd@adobehc.nhs.uk"
              #   },
              #   {
              #     address: {
              #       line: "TODO",
              #       city: "TODO",
              #       postalCode: "TODO"
              #     }
              #   }
              # ]
            )
          }
        end
      end
    end
  end
end
