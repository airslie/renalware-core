require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for converting a relation Observation to a range
    #
    class ObservationDateRange
      def self.build(values)
        Range.new(values.first, values.last + 1.day)
      end
    end
  end
end
