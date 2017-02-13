require_dependency "renalware/letters"

module Renalware
  module Letters
    class Event::ClinicalLetter < Event
      def description
        "(Clinic Letter #{::I18n.l(date.to_date, format: :long)})"
      end

      def part_classes
        {
          problems: Part::Problems,
          prescriptions: Part::Prescriptions,
          recent_pathology_results: Part::RecentPathologyResults,
          clinical_observations: Part::ClinicalObservations
        }
      end

      def to_s
        "Clinic Letter"
      end
    end
  end
end
