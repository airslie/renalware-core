# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class DoseUnit
      def self.codes
        %i(
          ampoule
          capsule
          drop
          gram
          international_unit
          microgram
          milligram
          millilitre
          puff
          tab
          tablet
          unit
        )
      end
    end
  end
end
