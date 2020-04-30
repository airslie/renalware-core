# frozen_string_literal: true

require_dependency "renalware/clinics"

# The body surface area (BSA) of a patient calculated using DuBois/DuBois
# BSA = 0.007184 * Height^0.725 * Weight^0.425
# Resources:
# - Calculators
#   - https://www.msdmanuals.com/en-gb/medical-calculators/BodySurfaceArea.htm
#   - http://www.medcalc.com/body.html
module Renalware
  module Clinics
    class BodySurfaceArea
      pattr_initialize [:visit!]

      def self.calculate(visit:, dp: 2)
        new(visit: visit).calculate(dp: dp)
      end

      def calculate(dp: 2)
        return if height_cm.zero?
        return if weight_kg.zero?

        # NB ** is ruby syntax for power of (^)
        result = 0.007184 * (weight_kg**0.425) * (height_cm**0.725)
        result.round(dp)
      end

      private

      def height_cm
        visit&.height.to_f * 100
      end

      def weight_kg
        visit&.weight.to_f
      end
    end
  end
end
