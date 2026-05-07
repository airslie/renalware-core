# frozen_string_literal: true


module Renalware
  module Heroic
    module Events
      class Mgfr < HeroicEvent
        class Document < Heroic::Document
          MAX_VISIT_NUMBER = 2
          attribute :visit_number, Integer
          attribute :uncorrected_bsa, Float

          validates(
            :visit_number,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: MAX_VISIT_NUMBER
            },
            allow_nil: true
          )

          validates(
            :uncorrected_bsa,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 200
            },
            allow_nil: true
          )
        end
        has_document
      end
    end
  end
end
