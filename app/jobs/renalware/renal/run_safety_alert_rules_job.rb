module Renalware
  module Renal
    class RunSafetyAlertRulesJob < ApplicationJob
      queue_as :default

      def perform(safety_alert_rule_id = nil)
        rules =
          if safety_alert_rule_id
            SafetyAlertRule.where(id: safety_alert_rule_id)
          else
            SafetyAlertRule.enabled.ordered
          end

        SafetyAlerts::Runner.new(rules: rules).call
      end
    end
  end
end
