require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalAlgorithm
        def initialize(patient, clinic)
          @patient = patient
          @clinic = clinic
        end

        def determine_required_request_descriptions
          rule_sets
            .select { |rule_set| rule_set.observation_required_for_patient?(@patient) }
            .map { |rule_set| rule_set.request_description }
            .uniq
        end

        private

        def rule_sets
          GlobalRuleSet.for_clinic(@clinic).ordered
        end
      end
    end
  end
end
