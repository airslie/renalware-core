require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRuleSetPresenter < SimpleDelegator
        def self.present(rule_sets)
          rule_sets.map { |rule_set| new rule_set }
        end

        def rules
          ::Renalware::Pathology::Requests::GlobalRulePresenter.present(super)
        end

        def to_s
          rules.map { |rule| rule.to_s }.join(" and ")
        end
      end
    end
  end
end
