module Renalware
  module Admin
    class SafetyAlertRulesController < BaseController
      def index
        rules = Renal::SafetyAlertRule.ordered
        authorize rules

        pagy, rules = pagy(rules)
        render locals: { rules: rules, pagy: pagy }
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
    end
  end
end
