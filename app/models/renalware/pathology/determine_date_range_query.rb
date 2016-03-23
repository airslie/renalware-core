require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for finding the date range of a patient's observations
    # for the specified limit.
    #
    class DetermineDateRangeQuery
      attr_reader :limit

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
