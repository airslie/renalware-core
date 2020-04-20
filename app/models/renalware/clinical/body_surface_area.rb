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
      pattr_initialize [:patient!, dp: 3]

      def calculate
        return 0 if most_recent_height.zero?
        return 0 if most_recent_weight.zero?

        # NB ** is ruby syntax for power of (^)
        result = 0.007184 * (most_recent_weight**0.425) * (most_recent_height**0.725)
        result.round(dp)
      end

      def most_recent_height
        @most_recent_height ||= most_recent(:height)
      end

      def most_recent_weight
        @most_recent_weight ||= most_recent(:weight)
      end

      def most_recent(measurement)
        Clinics::ClinicVisit
          .for_patient(patient)
          .where("#{measurement} > 0")
          .order(date: :desc, created_at: :desc)
          .limit(1)
          .pluck(measurement.to_sym)
          .first
          .to_f
      end
    end
  end
end
