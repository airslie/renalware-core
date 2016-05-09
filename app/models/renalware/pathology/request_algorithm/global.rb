require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Global
        def initialize(patient, clinic)
          @patient = patient
          @clinic = clinic
        end

        def required_pathology
          rule_sets
            .select { |rule_set| rule_set.required_for_patient?(@patient) }
            .map { |rule_set| rule_set.request_description }
            .uniq
        end

        private

        def rule_sets
          GlobalRuleSet.where(clinic: @clinic)
        end
      end
    end
  end
end
