require_dependency "renalware/letters"

module Renalware
  module Letters
    class Event::ClinicVisit < Event
      def description
        "(Clinic Date #{::I18n.l(date.to_date, format: :long)})"
      end

      def part_classes
        {
          current_medications: Part::CurrentMedications,
          clinical_observations: Part::ClinicalObservations,
          problems: Part::Problems
        }
      end

      def to_s
        "Clinic Visit"
      end
    end
  end
end
