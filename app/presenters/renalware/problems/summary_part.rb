require_dependency "renalware/problems"

module Renalware
  module Problems
    class SummaryPart < Renalware::SummaryPart
      delegate :cache_key, to: :problems

      def problems
        @problems ||= patient.problems.ordered
      end

      def to_partial_path
        "renalware/problems/problems/summary_part"
      end
    end
  end
end
