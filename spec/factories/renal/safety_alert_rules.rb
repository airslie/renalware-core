FactoryBot.define do
  factory :renal_safety_alert_rule, class: "Renalware::Renal::SafetyAlertRule" do
    sequence(:name) { |n| "Safety alert rule #{n}" }
    sequence(:function_name) { |n| "renalware.safety_alert_rule_#{n}" }
    enabled { true }
  end
end
