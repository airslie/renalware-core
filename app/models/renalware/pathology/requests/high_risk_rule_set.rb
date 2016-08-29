require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class HighRiskRuleSet
        def self.rules
          GlobalRule.where(rule_set_type: self.class.name)
        end

        def self.patient_is_high_risk?(patient)
          true
        end
      end
    end
  end
end
