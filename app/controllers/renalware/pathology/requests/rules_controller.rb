require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RulesController < Pathology::BaseController
        # NOTE: These ids are in a specific order to match the Bart's pathology algorithm doc
        CLINIC_IDS = [10, 4, 11, 15, 9, 8]
        REQUEST_DESCRIPTION_IDS = [10, 9, 11, 144, 152, 38, 5, 154, 176, 50, 58, 17, 92, 48, 30,
          177, 89, 13, 116, 67, 178, 52, 21, 20, 179, 139, 180, 181, 71, 81, 1, 25, 6, 7, 18, 182,
          155, 183, 170, 184, 185, 186, 187, 188, 189, 190, 191, 192, 189, 193, 194, 195]

        def index
          rule_sets = GlobalRuleSet.all
          authorize rule_sets

          rules_table = ::Renalware::Pathology::Requests::GlobalRuleSetsTable.new(
            Renalware::Pathology::OrderedRequestDescriptionQuery.new(REQUEST_DESCRIPTION_IDS).call,
            Renalware::Clinics::OrderedClinicQuery.new(CLINIC_IDS).call,
            GlobalRuleSetPresenter.present(rule_sets)
          )

          render :index, locals: { rules_table: rules_table }
        end
      end
    end
  end
end
