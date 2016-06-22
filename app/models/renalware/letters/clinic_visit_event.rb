require_dependency "renalware/letters"

module Renalware
  module Letters
    class ClinicVisitEvent < DumbDelegator
      def description
        "(Clinic Date #{::I18n.l(date.to_date, format: :long)})"
      end

      def part_classes
        {
          current_medications: Part::CurrentMedications
        }
      end

      def to_s
        "Clinic Visit"
      end
    end
  end
end
