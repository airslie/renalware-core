require_dependency "renalware/letters"

module Renalware
  module Letters
    class Event::ClinicVisit < Event
      def description
        "(Clinic Date #{::I18n.l(date.to_date, format: :long)})"
      end

      def part_classes
        {
          problems: Part::Problems,
          current_medications: Part::CurrentMedications,
          recent_pathology_results: Part::RecentPathologyResults,
          clinical_observations: Part::ClinicalObservations
        }
      end

      def to_s
        "Clinic Visit"
      end
    end
  end
end
