require_dependency "renalware/letters"

module Renalware
  module Letters
    class UnknownEvent
      def description
      end

      def part_classes
        []
      end

      def to_s
        "Simple"
      end
    end
  end
end
