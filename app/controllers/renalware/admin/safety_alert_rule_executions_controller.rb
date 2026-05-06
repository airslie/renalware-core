module Renalware
  module Admin
    class SafetyAlertRuleExecutionsController < BaseController
      def index
        executions = filtered_executions
        authorize executions

        pagy, executions = pagy(executions)
        render locals: {
          executions: executions,
          pagy: pagy,
          rules: Renal::SafetyAlertRule.ordered,
          selected_rule_id: selected_rule_id
        }
      end

      private

      def filtered_executions
        Renal::SafetyAlertRuleExecution
          .includes(:safety_alert_rule)
          .ordered
          .then { |scope| filter_by_rule(scope) }
      end

      def filter_by_rule(scope)
        return scope if selected_rule_id.blank?

        scope.where(safety_alert_rule_id: selected_rule_id)
      end

      def selected_rule_id
        params[:safety_alert_rule_id].presence
      end
    end
  end
end
