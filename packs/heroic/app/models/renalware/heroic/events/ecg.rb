# frozen_string_literal: true


module Renalware
  module Heroic
    module Events
      class Ecg < HeroicEvent
        class Document < Heroic::Document
          MAX_VISIT_NUMBER = 2
          attribute :visit_number, Integer

          validates(
            :visit_number,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: MAX_VISIT_NUMBER
            },
            allow_nil: true
          )
        end
        has_document
      end
    end
  end
end
