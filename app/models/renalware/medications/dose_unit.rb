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
          millimole
          nanogram
          patch
          puff
          sachet
          tab
          tablespoon
          tablet
          teaspoon
          unit
        )
      end
    end
  end
end
