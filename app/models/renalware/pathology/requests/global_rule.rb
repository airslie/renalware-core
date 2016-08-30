require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRule < ActiveRecord::Base
        PARAM_COMPARISON_OPERATORS = ["==", ">", "<", ">=", "<=", "include?"]

        belongs_to :rule_set, polymorphic: true

        validates :rule_set, presence: true
        validates :param_comparison_operator, inclusion:
          { in: PARAM_COMPARISON_OPERATORS, allow_nil: true }

        def observation_required_for_patient?(_patient, _date)
          raise NotImplementedError
        end

        def to_s
          raise NotImplementedError
        end
      end
    end
  end
end
