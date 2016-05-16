require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class GlobalRule < ActiveRecord::Base
        PARAM_COMPARISON_OPERATORS = ["==", ">", "<", ">=", "<=", "include?"]

        belongs_to :global_rule_set

        validates :global_rule_set, presence: true
        validates :param_comparison_operator, inclusion:
          { in: PARAM_COMPARISON_OPERATORS, allow_nil: true }

        def required_for_patient?(patient)
          param_type_class =
            "::Renalware::Pathology::RequestAlgorithm::ParamType::#{param_type}"
            .constantize

          param_type_class
            .new(
              patient,
              param_id,
              param_comparison_operator,
              param_comparison_value
            )
            .patient_requires_test?
        end
      end
    end
  end
end
