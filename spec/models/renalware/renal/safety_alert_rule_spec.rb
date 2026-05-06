describe Renalware::Renal::SafetyAlertRule do
  it :aggregate_failures do
    is_expected.to validate_presence_of(:name)
    is_expected.to validate_presence_of(:function_name)
  end

  it "validates function names are schema-qualified identifiers, not arbitrary SQL" do
    rule = build(:renal_safety_alert_rule, function_name: "renalware.fn; drop table patients")

    expect(rule).not_to be_valid
    expect(rule.errors[:function_name]).to be_present
  end

  it "quotes a schema-qualified function name for execution" do
    rule = build(:renal_safety_alert_rule, function_name: "renalware.example_safety_alert_rule")

    expect(rule.quoted_function_name).to eq('"renalware"."example_safety_alert_rule"')
  end
end
