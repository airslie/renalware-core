# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources
      module GPConnect
        # FHIR resource representing a letter
        class Composition
          include Support::Construction
          include Support::Helpers

          # rubocop:disable Metrics/MethodLength
          def call
            {
              fullUrl: arguments.letter_urn,
              resource: FHIR::STU3::Composition.new(
                id: arguments.letter_uuid,
                title: letter.description,
                date: letter.updated_at.to_datetime.to_s,
                author: {
                  reference: arguments.author_urn
                },
                meta: {
                  profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-OPL-Composition-1"
                },
                status: "final",
                type: snomed_coding("823681000000100", "Outpatient letter"),
                identifier: system_identifier(SecureRandom.uuid), # TODO
                subject: {
                  reference: arguments.patient_urn
                },
                # Identifies the organization responsible for
                # ongoing maintenance of and access to the composition/document information.
                custodian: {
                  reference: arguments.organisation_urn
                },
                # Extension to carry details of the Correspondence Care Setting Type
                extension: {
                  url: "https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-CareSettingType-1",
                  valueCodeableConcept: {
                    coding: {
                      system: "http://snomed.info/sct",
                      code: "788003006",
                      display: "Nephrology service"
                    }
                  }
                },
                # Reference to the clinical encounter or type of care this documentation is
                # associated with.
                encounter: {
                  reference: arguments.encounter_urn
                },
                section: []
              )
            }
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
