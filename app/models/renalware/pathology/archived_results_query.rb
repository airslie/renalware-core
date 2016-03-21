require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ArchivedResultsQuery
      def initialize(patient:)
        @patient = patient
      end

      def call
        @patient.observations.ordered
      end
    end
  end
end
