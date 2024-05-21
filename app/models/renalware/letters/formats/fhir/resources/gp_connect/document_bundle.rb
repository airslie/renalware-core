# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR
    module Resources
      module GPConnect
        class DocumentBundle < Resources::DocumentBundle
          def entries
            [
              GPConnect::Composition.call(arguments),
              Patient.call(arguments),
              Author.call(arguments),
              Organisation.call(arguments),
              Binary.call(arguments)
            ]
          end
        end
      end
    end
  end
end
