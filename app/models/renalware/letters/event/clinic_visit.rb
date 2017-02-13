require_dependency "renalware/letters"

module Renalware
  module Letters
    class Event::ClinicVisit < Event
      def initialize(event, clinical:)
        super(event, clinical: true)
      end

      def description
        "(Clinic Date #{::I18n.l(date.to_date, format: :long)})"
      end

      def part_classes
        super.merge!({ clinical_observations: Part::ClinicalObservations })
      end

      def to_s
        "Clinic Visit"
      end
    end
  end
end
