# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      #
      # FHIR resource representing the letter author
      #
      class Resources::Practitioner
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
              # There a couple of options for resolving a user by identifier
              # - GPC number
              # - SDS (Spine Directory Service) number
              # We currently have neither by SDS best if we can get it
              # identifier: {
              #   system: "https://fhir.hl7.org.uk/Id/hcpc-number",
              #   value: "????" # TODO: GPC number
              # },
              # identifier: {
              #   system: "https://fhir.nhs.uk/Id/sds-user-id",
              #   value: "????" # TODO: SDS number
              # },
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
