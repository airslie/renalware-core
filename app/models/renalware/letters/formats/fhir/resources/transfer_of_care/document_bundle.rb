# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR
    module Resources
      module TransferOfCare
        class DocumentBundle < Resources::DocumentBundle
          def entries
            [
              Composition.call(arguments), # letter in html sections
              Patient.call(arguments),
              Encounter.call(arguments), # clinic visit details if relevant
              Author.call(arguments),
              Organisation.call(arguments)
            ]
          end
        end
      end
    end
  end
end
