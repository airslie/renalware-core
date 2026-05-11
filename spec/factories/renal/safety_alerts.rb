FactoryBot.define do
  factory :renal_safety_alert, class: "Renalware::Renal::SafetyAlert" do
    patient factory: :renal_patient
    safety_alert_rule factory: :renal_safety_alert_rule
    rule_name { safety_alert_rule.name }
    label { "Example safety alert" }
    metadata { {} }
    notes { nil }
  end
end
