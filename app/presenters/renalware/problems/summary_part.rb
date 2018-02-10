require_dependency "renalware/problems"

module Renalware
  module Problems
    class SummaryPart < Renalware::SummaryPart
      def current_problems
        @current_problems ||= patient.problems.current.ordered
      end

      # def cache_key
      #   current_problems.maximum(:updated_at)
      # end

      def to_partial_path
        "renalware/problems/problems/summary_part"
      end
    end
  end
end
