describe Renalware::Renal::SafetyAlertRuleCategory do
  it :aggregate_failures do
    is_expected.to have_many(:safety_alert_rules).dependent(:restrict_with_exception)
    is_expected.to validate_presence_of(:name)
  end

  it "validates name uniqueness" do
    create(:renal_safety_alert_rule_category, name: "General")

    category = build(:renal_safety_alert_rule_category, name: "General")

    expect(category).not_to be_valid
    expect(category.errors[:name]).to be_present
  end
end
