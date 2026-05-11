describe Renalware::Renal::RunSafetyAlertRulesJob do
  it "delegates enabled rules to the safety alert runner" do
    runner = instance_double(Renalware::Renal::SafetyAlerts::Runner, call: true)
    allow(Renalware::Renal::SafetyAlerts::Runner).to receive(:new).and_return(runner)

    described_class.perform_now

    expect(Renalware::Renal::SafetyAlerts::Runner).to have_received(:new).with(
      rules: Renalware::Renal::SafetyAlertRule.enabled.ordered
    )
    expect(runner).to have_received(:call)
  end

  it "delegates a single rule to the safety alert runner" do
    rule = create(:renal_safety_alert_rule, enabled: false)
    runner = instance_double(Renalware::Renal::SafetyAlerts::Runner, call: true)
    allow(Renalware::Renal::SafetyAlerts::Runner).to receive(:new).and_return(runner)

    described_class.perform_now(rule.id)

    expect(Renalware::Renal::SafetyAlerts::Runner).to have_received(:new).with(
      rules: Renalware::Renal::SafetyAlertRule.where(id: rule.id)
    )
    expect(runner).to have_received(:call)
  end
end
