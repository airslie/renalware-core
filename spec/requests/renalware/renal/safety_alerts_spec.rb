describe "Renal safety alerts" do
  let(:patient) { create(:renal_patient, :minimal, family_name: "Bloggs", given_name: "Jane") }
  let(:rule) { create(:renal_safety_alert_rule, name: "Positive MSSA screen") }
  let!(:alert) do
    create(
      :renal_safety_alert,
      patient: patient,
      safety_alert_rule: rule,
      rule_name: rule.name,
      alert_type: "MSSA screen positive"
    )
  end

  describe "GET index" do
    it "lists active alerts" do
      get renal_safety_alerts_path

      expect(response).to be_successful
      expect(response.body).to include("Active")
      expect(response.body).to include("Historical")
      expect(response.body).to include("BLOGGS, Jane")
      expect(response.body).to include("Positive MSSA screen")
      expect(response.body).to include("MSSA screen positive")
    end

    it "does not list resolved alerts" do
      alert.update!(deleted_at: Time.zone.now)

      get renal_safety_alerts_path

      expect(response).to be_successful
      expect(response.body).not_to include("Positive MSSA screen")
    end
  end

  describe "GET historical" do
    it "lists resolved alerts" do
      alert.update!(deleted_at: Time.zone.now)

      get historical_renal_safety_alerts_path

      expect(response).to be_successful
      expect(response.body).to include("Active")
      expect(response.body).to include("Historical")
      expect(response.body).to include("BLOGGS, Jane")
      expect(response.body).to include("Positive MSSA screen")
      expect(response.body).to include("Resolved at")
    end
  end

  describe "DELETE destroy" do
    it "resolves the alert" do
      delete renal_safety_alert_path(alert)

      expect(response).to redirect_to(renal_safety_alerts_path)
      expect(alert.reload.deleted_at).to be_present
    end
  end
end
