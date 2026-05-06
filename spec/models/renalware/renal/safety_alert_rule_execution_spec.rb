describe Renalware::Renal::SafetyAlertRuleExecution do
  it :aggregate_failures do
    is_expected.to belong_to(:safety_alert_rule)
    is_expected.to validate_presence_of(:started_at)
    is_expected.to validate_presence_of(:status)
    is_expected.to validate_inclusion_of(:status).in_array(%w(running succeeded failed))
  end

  it "records completion metadata" do
    execution = create(:renal_safety_alert_rule_execution, started_at: 1.second.ago)

    execution.finish!(status: "succeeded", matched_count: 2, created_count: 1)

    expect(execution).to have_attributes(
      status: "succeeded",
      matched_count: 2,
      created_count: 1
    )
    expect(execution.finished_at).to be_present
    expect(execution.duration_ms).to be_positive
  end
end
