require_dependency "renalware/letters"

module Renalware
  module Letters
    class Event < DumbDelegator
      def initialize(object=nil)
        super(object)
      end

      def description
        raise NotImplementedError
      end

      def part_classes
        {}
      end

      def to_s
        raise NotImplementedError
      end
    end
  end
end
