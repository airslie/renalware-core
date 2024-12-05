# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources
      module GPConnect
        # FHIR resource representing a letter
        class Composition
          include Support::Construction
          include Support::Helpers

          PROFILE_URL = "https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Composition-1"

          def call
            {
              fullUrl: arguments.letter_urn,
              resource: ::FHIR::STU3::Composition.new(
                id: arguments.letter_uuid,
                identifier: system_identifier(SecureRandom.uuid), # TODO
                meta: {
                  profile: PROFILE_URL
                },
                status: "final",
                type: {
                  coding: [
                    snomed_coding_content(
                      "371531000",
                      "Report of clinical encounter (record artifact)"
                    )
                  ],
                  text: "Report of clinical encounter (record artifact)"
                },
                subject: {
                  reference: arguments.patient_urn
                },
                date: letter.updated_at.to_date.to_s,
                author: {
                  reference: arguments.author_urn
                },
                custodian: {
                  reference: arguments.organisation_urn
                },
                title: arguments.document_title,
                confidentiality: arguments.confidentiality,
                section: {
                  entry: [
                    { reference: arguments.organisation_urn },
                    { reference: arguments.author_urn },
                    { reference: arguments.patient_urn },
                    { reference: arguments.binary_urn }
                  ]
                }
              )
            }
          end
        end
      end
    end
  end
end
