require_dependency "renalware/letters"

module Renalware
  module Letters
    class Event < DumbDelegator
      attr_reader :clinical
      alias_method :clinical?, :clinical

      def initialize(event = nil, clinical: false)
        @clinical = clinical
        super(event)
      end

      def description
        raise NotImplementedError
      end

      def part_classes
        return clinical_part_classes if clinical?
        {}
      end

      def to_s
        raise NotImplementedError
      end

      private

      def clinical_part_classes
        {
          problems: Part::Problems,
          prescriptions: Part::Prescriptions,
          pathology_snapshot: Part::PathologySnapshot,
          allergies: Part::Allergies
        }
      end
    end
  end
end
