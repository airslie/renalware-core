require_dependency "renalware/letters/event"

module Renalware
  module Letters
    class Event::Unknown < Event
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
