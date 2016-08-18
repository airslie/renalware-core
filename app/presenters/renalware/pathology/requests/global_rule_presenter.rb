require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRulePresenter < SimpleDelegator
        def self.present(rules)
          rules.map { |rule| new rule }
        end

        def param
          param_type_class =
            "::Renalware::Pathology::Requests::GlobalRule::#{param_type}"
            .constantize

          param_type_class
            .new(
              nil,
              param_id,
              param_comparison_operator,
              param_comparison_value
            )
        end

        def to_s
          "if #{param} then #{global_rule_set.frequency}"
        end
      end
    end
  end
end
