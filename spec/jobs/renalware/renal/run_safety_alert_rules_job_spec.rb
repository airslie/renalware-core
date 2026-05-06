describe Renalware::Renal::RunSafetyAlertRulesJob do
  it "delegates to the safety alert runner" do
    runner = instance_double(Renalware::Renal::SafetyAlerts::Runner, call: true)
    allow(Renalware::Renal::SafetyAlerts::Runner).to receive(:new).and_return(runner)

    described_class.perform_now

    expect(runner).to have_received(:call)
  end
end
