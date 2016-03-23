require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for finding a patient's most recent observations results
    # with in a specified date range.
    #
    class ObservationsWithinDateRangeQuery
      attr_reader :limit

      def initialize(patient:, date_range:)
        @patient = patient
        @date_range = date_range
      end

      def call
        @patient
          .observations
          .where(observed_at: @date_range)
          .ordered
      end
    end
  end
end
