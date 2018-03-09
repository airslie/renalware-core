# frozen_string_literal: true

require_dependency "renalware/problems"

module Renalware
  module Problems
    class SummaryPart < Renalware::SummaryPart
      def problems
        @problems ||= patient.problems.ordered
      end

      def cache_key
        [patient.cache_key, patient.problems.cache_key].join("~")
      end

      def to_partial_path
        "renalware/problems/problems/summary_part"
      end
    end
  end
end
