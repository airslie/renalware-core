# frozen_string_literal: true

require_dependency "renalware/clinical"
require "document/base"

# The body surface area (BSA) of a patient calculated using DuBois/DuBois
# BSA = 0.007184 * Height^0.725 * Weight^0.425
# Resources:
# - Calculators
#   - https://www.msdmanuals.com/en-gb/medical-calculators/BodySurfaceArea.htm
#   - http://www.medcalc.com/body.html
module Renalware
  module Clinical
    class BodySurfaceArea
      pattr_initialize [:patient!]

      def calculate(dp: 2)
        return 0 if most_recent_height_cm.zero?
        return 0 if most_recent_weight_kg.zero?

        # NB ** is ruby syntax for power of (^)
        result = 0.007184 * (most_recent_weight_kg**0.425) * (most_recent_height_cm**0.725)
        result.round(dp)
      end

      def most_recent_height_cm
        most_recent_visit_where_weight_was_measured&.height.to_f * 100
      end

      def most_recent_weight_kg
        most_recent_visit_where_weight_was_measured&.weight.to_f
      end

      def most_recent_visit_where_weight_was_measured
        @most_recent_visit_where_weight_was_measured ||= begin
          Clinics::ClinicVisit
            .most_recent_for_patient(patient)
            .where_weight_was_measured
            .select(:weight, :height)
            .first
        end
      end
    end
  end
end
