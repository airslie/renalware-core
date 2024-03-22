# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR
    module Resources
      module GPConnect
        class DocumentBundle < Resources::DocumentBundle
          def entries
            [
              Resources::GPConnect::Composition.call(arguments),
              Resources::Patient.call(arguments),
              Resources::Author.call(arguments),
              Resources::Organisation.call(arguments)
              # GPConnect::Binary  todo
            ]
          end
        end
      end
    end
  end
end
