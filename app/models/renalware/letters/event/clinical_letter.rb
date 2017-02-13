require_dependency "renalware/letters"

module Renalware
  module Letters
    class Event::ClinicalLetter < Event
      def description
        ""
      end

      def part_classes
        {
          problems: Part::Problems,
          prescriptions: Part::Prescriptions,
          recent_pathology_results: Part::RecentPathologyResults
        }
      end

      def to_s
        "Clinic Letter"
      end
    end
  end
end
