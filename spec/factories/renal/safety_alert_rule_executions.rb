FactoryBot.define do
  factory :renal_safety_alert_rule_execution,
          class: "Renalware::Renal::SafetyAlertRuleExecution" do
    safety_alert_rule factory: :renal_safety_alert_rule
    started_at { Time.zone.now }
    status { "running" }
  end
end
