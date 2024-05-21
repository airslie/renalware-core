# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources
      module GPConnect
        # FHIR resource representing a letter
        class Composition
          include Support::Construction
          include Support::Helpers

          def call
            {
              fullUrl: arguments.letter_urn,
              resource: FHIR::STU3::Composition.new(
                id: arguments.letter_uuid,
                identifier: system_identifier(SecureRandom.uuid), # TODO
                status: "final",
                type: {
                  **snomed_coding("823681000000100", "Outpatient letter"),
                  text: "Outpatient letter"
                },
                subject: {
                  reference: arguments.patient_urn
                },
                date: letter.updated_at.to_datetime.to_s,
                author: {
                  reference: arguments.author_urn
                },
                title: letter.description,
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
