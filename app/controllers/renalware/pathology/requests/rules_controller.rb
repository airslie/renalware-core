require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RulesController < Pathology::BaseController
        def index
          rule_sets = GlobalRuleSet.all
          authorize rule_sets

          rules_table = ::Renalware::Pathology::Requests::GlobalRuleSetsTable.new(
            Renalware::Pathology::RequestDescription.with_global_rule_set,
            Renalware::Clinics::Clinic.all,
            GlobalRuleSetPresenter.present(rule_sets)
          )

          render :index, locals: { rules_table: rules_table }
        end
      end
    end
  end
end
