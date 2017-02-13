require_dependency "renalware/letters/event"

module Renalware
  module Letters
    class Event::Unknown < Event

      def description; end

      def to_s
        clinical? ? "Clinical" : "Simple"
      end
    end
  end
end
