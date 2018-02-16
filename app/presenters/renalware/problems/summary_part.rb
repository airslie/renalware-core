require_dependency "renalware/problems"

module Renalware
  module Problems
    class SummaryPart < Renalware::SummaryPart
      def problems
        @problems ||= patient.problems.ordered
      end

      def cache_key
        problems.maximum(:updated_at)
      end

      def to_partial_path
        "renalware/problems/problems/summary_part"
      end
    end
  end
end
