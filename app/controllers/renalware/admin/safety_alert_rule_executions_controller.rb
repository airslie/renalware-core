module Renalware
  module Admin
    class SafetyAlertRuleExecutionsController < BaseController
      def index
        executions = filtered_executions
        authorize executions

        pagy, executions = pagy(executions)
        render locals: {
          categories: Renal::SafetyAlertRuleCategory.ordered,
          executions: executions,
          grouped_rule_options: Renal::SafetyAlertRule.grouped_options_for_select,
          pagy: pagy,
          selected_category_id: selected_category_id,
          selected_rule_id: selected_rule_id
        }
      end

      private

      def filtered_executions
        Renal::SafetyAlertRuleExecution
          .includes(safety_alert_rule: :safety_alert_rule_category)
          .ordered
          .then { |scope| filter_by_category(scope) }
          .then { |scope| filter_by_rule(scope) }
      end

      def filter_by_category(scope)
        return scope if selected_category_id.blank?

        scope
          .joins(:safety_alert_rule)
          .where(
            renal_safety_alert_rules: {
              safety_alert_rule_category_id: selected_category_id
            }
          )
      end

      def filter_by_rule(scope)
        return scope if selected_rule_id.blank?

        scope.where(safety_alert_rule_id: selected_rule_id)
      end

      def selected_category_id
        params[:safety_alert_rule_category_id].presence
      end

      def selected_rule_id
        params[:safety_alert_rule_id].presence
      end
    end
  end
end
