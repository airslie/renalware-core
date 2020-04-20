# frozen_string_literal: true

require_dependency "renalware/clinical"

# Total Body Water (TBW) calcuated using WATSON
# References:
# - https://qxmd.com/calculate/calculator_344/total-body-water-watson-formula
#
# Total Body Water
#   TBW = 2.447 - 0.09156 X age + 0.1074 X height + 0.3362 X weight
#   (females) TBW = -2.097 + 0.1069 X height + 0.2466 X weight
#
# Water in Litres
# Age in years
# Height in cm
# Weight in kg
# rubocop:disable Lint/AssignmentInCondition
module Renalware
  module Clinical
    class TotalBodyWater
      pattr_initialize [:patient!]
      delegate :age, to: :patient

      NOTHING = 0
      SEX_PROC_MAP = {
        M: ->(age:, height:, weight:) { 2.447 - 0.09156 * age + 0.1074 * height + 0.3362 * weight },
        F: ->(height:, weight:, **) { -2.097 + 0.1069 * height + 0.2466 * weight }
      }.freeze
      NOOP = ->(**) { NOTHING }

      def calculate(dp: 2)
        return NOTHING if most_recent_height_cm.zero?
        return NOTHING if most_recent_weight_kg.zero?
        return NOTHING if age.to_i.zero?
        return NOTHING unless

        proc_for_sex = SEX_PROC_MAP.fetch(sex, NOOP)

        proc_for_sex.call(
          age: age,
          height: most_recent_height_cm,
          weight: most_recent_weight_kg
        ).round(dp)
      end

      private

      # Note sex can be nil but here that would evaluate to :""
      def sex
        patient.sex.to_s&.to_sym
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
# rubocop:enable Lint/AssignmentInCondition
