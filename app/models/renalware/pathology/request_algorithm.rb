require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      def initialize(patient, group)
        raise ArgumentError unless Rule::GROUPS.include?(group)
        @patient = patient
        @group = group
      end

      def required_pathology
        # TODO: Combine the results from global & patient algorithm
      end
    end
  end
end
