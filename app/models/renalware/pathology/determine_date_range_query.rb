require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class DetermineDateRangeQuery
      def initialize(patient:, limit: 20)
        @patient = patient
        @limit = limit
      end

      def call
        values = @patient
          .observations
          .ordered
          .distinct(:observed_at)
          .limit(@limit)
          .pluck(:observed_at)
          .reverse

        Range.new(values.first, values.last)
      end
    end
  end
end
