describe Renalware::Renal::SafetyAlert do
  it :aggregate_failures do
    is_expected.to belong_to(:patient)
    is_expected.to belong_to(:safety_alert_rule)
    is_expected.to belong_to(:safety_alert_rule_execution).optional
    is_expected.to belong_to(:deleted_by).optional
    is_expected.to validate_presence_of(:patient)
    is_expected.to validate_presence_of(:safety_alert_rule)
    is_expected.to validate_presence_of(:rule_name)
  end

  it "allows only one active alert for a patient and rule" do
    alert = create(:renal_safety_alert)
    duplicate = build(
      :renal_safety_alert,
      patient: alert.patient,
      safety_alert_rule: alert.safety_alert_rule
    )

    expect(duplicate).not_to be_valid
  end

  it "allows a new alert when the previous one has been resolved" do
    alert = create(:renal_safety_alert, deleted_at: Time.zone.now)
    duplicate = build(
      :renal_safety_alert,
      patient: alert.patient,
      safety_alert_rule: alert.safety_alert_rule
    )

    expect(duplicate).to be_valid
  end

  it "resolves an alert with the resolving user" do
    user = create(:user)
    alert = create(:renal_safety_alert)

    alert.resolve!(by: user, notes: "Reviewed and resolved")

    expect(alert.deleted_at).to be_present
    expect(alert.deleted_by).to eq(user)
    expect(alert.notes).to eq("Reviewed and resolved")
  end
end
