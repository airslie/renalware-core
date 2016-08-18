require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRule < ActiveRecord::Base
        PARAM_COMPARISON_OPERATORS = ["==", ">", "<", ">=", "<=", "include?"]

        belongs_to :global_rule_set

        validates :global_rule_set, presence: true
        validates :param_comparison_operator, inclusion:
          { in: PARAM_COMPARISON_OPERATORS, allow_nil: true }

        def observation_required_for_patient?(patient)
          raise NotImplementedError
        end

        def to_s
          raise NotImplementedError
        end
      end
    end
  end
end
