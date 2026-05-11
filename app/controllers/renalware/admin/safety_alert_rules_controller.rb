module Renalware
  module Admin
    class SafetyAlertRulesController < BaseController
      def index
        rules = filtered_rules
        authorize rules

        pagy, rules = pagy(rules)
        render locals: {
          categories: Renal::SafetyAlertRuleCategory.ordered,
          pagy: pagy,
          rules: rules,
          selected_category_id: selected_category_id
        }
      end

      def enable
        safety_alert_rule.update!(enabled: true)
        redirect_to admin_safety_alert_rules_path, notice: "Safety alert rule updated"
      end

      def disable
        safety_alert_rule.update!(enabled: false)
        redirect_to admin_safety_alert_rules_path, notice: "Safety alert rule updated"
      end

      def run
        Renal::RunSafetyAlertRulesJob.perform_later(safety_alert_rule.id)
        redirect_to admin_safety_alert_rules_path, notice: "Safety alert rule queued"
      end

      private

      def safety_alert_rule
        @safety_alert_rule ||= Renal::SafetyAlertRule.find(params[:id]).tap do |rule|
          authorize rule
        end
      end

      def filtered_rules
        Renal::SafetyAlertRule
          .includes(:safety_alert_rule_category)
          .ordered
          .then { |scope| filter_by_category(scope) }
      end

      def filter_by_category(scope)
        return scope if selected_category_id.blank?

        scope.where(safety_alert_rule_category_id: selected_category_id)
      end

      def selected_category_id
        params[:safety_alert_rule_category_id].presence
      end
    end
  end
end
