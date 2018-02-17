require_dependency "renalware/problems"

module Renalware
  module Problems
    class SummaryPart < Renalware::SummaryPart
      def problems
        @problems ||= patient.problems.ordered
      end

      def cache_key
        [
          to_partial_path,
          patient.id,
          patient.summary.problems_count,
          date_formatted_for_cache(max_updated_at)
        ].join(":")
      end

      def max_updated_at
        problems.maximum(:updated_at)
      end

      def to_partial_path
        "renalware/problems/problems/summary_part"
      end
    end
  end
end
