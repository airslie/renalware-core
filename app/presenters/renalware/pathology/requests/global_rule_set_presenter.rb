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
          if rules.any?
            rules.map { |rule| rule.to_s }.join(" and ")
          else
            frequency
          end
        end
      end
    end
  end
end
