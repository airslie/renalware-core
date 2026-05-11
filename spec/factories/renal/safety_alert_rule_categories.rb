FactoryBot.define do
  factory :renal_safety_alert_rule_category,
          class: "Renalware::Renal::SafetyAlertRuleCategory" do
    sequence(:name) { |n| "Safety alert category #{n}" }
  end
end
