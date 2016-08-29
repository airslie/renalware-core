require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class HighRiskRuleSet < ActiveRecord::Base
        has_no_table

        def self.rules
          GlobalRule.where(rule_set_type: self.class.name)
        end

        # NOTE: required so ActiveRecord doesn't try to create a new associated HighRiskRuleSet
        #       record with the audit
        def new_record?
          false
        end

        def id
          nil
        end
      end
    end
  end
end
