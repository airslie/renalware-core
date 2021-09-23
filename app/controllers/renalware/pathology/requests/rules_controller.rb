# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RulesController < Pathology::BaseController
        skip_after_action :verify_policy_scoped

        def index
          rule_sets = GlobalRuleSet.all
          clinics = Renalware::Pathology::Clinic.for_algorithm
          authorize rule_sets

          rules_table = GlobalRuleSetsTable.new(
            Renalware::Pathology::RequestDescription.with_global_rule_set,
            clinics,
            GlobalRuleSetPresenter.present(rule_sets)
          )

          render :index, locals: { rules_table: rules_table, clinics: clinics }
        end
      end
    end
  end
end
