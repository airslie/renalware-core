describe "Renal safety alerts" do
  let(:patient) { create(:renal_patient, :minimal, family_name: "Bloggs", given_name: "Jane") }
  let(:category) { create(:renal_safety_alert_rule_category, name: "Infection") }
  let(:rule) do
    create(
      :renal_safety_alert_rule,
      safety_alert_rule_category: category,
      name: "Positive MSSA screen"
    )
  end
  let!(:alert) do
    create(
      :renal_safety_alert,
      patient: patient,
      safety_alert_rule: rule,
      rule_name: rule.name,
      label: "MSSA screen positive"
    )
  end

  describe "GET index" do
    it "lists active alerts" do
      alert.update!(notes: "Review dialysis access")

      get renal_safety_alerts_path

      expect(response).to be_successful
      expect(response.body).to include("Active")
      expect(response.body).to include("Historical")
      expect(response.body).to include("BLOGGS, Jane")
      expect(response.body).to include("Positive MSSA screen")
      expect(response.body).to include("MSSA screen positive")
      expect(response.body).to include("Review dialysis access")
      expect(response.body).to include("All categories")
      expect(response.body).to include("All safety rules")
      expect(response.body).to include("<optgroup label=\"Infection\">")
    end

    it "shows modal controls for editing notes and resolving alerts" do
      get renal_safety_alerts_path

      expect(response).to be_successful
      expect(response.body).to include("Edit notes")
      expect(response.body).to include("Edit Safety Alert Notes")
      expect(response.body).to include("Save notes")
      expect(response.body).to include("Resolve Safety Alert")
      expect(response.body).not_to include('data-confirm="Are you sure?"')
    end

    it "uses unique form field ids for each notes dialog" do
      get renal_safety_alerts_path

      textarea_ids = Nokogiri::HTML5(response.body)
        .css("dialog textarea")
        .pluck("id")

      expect(response).to be_successful
      expect(textarea_ids).to contain_exactly(
        "edit_safety_alert_#{alert.id}_renal_safety_alert_notes",
        "resolve_safety_alert_#{alert.id}_renal_safety_alert_notes"
      )
      expect(textarea_ids.uniq).to eq(textarea_ids)
    end

    it "shows notes as read-only quick-preview content" do
      get renal_safety_alerts_path

      quick_preview = Nokogiri::HTML5(response.body).css("tr.quick-preview").text

      expect(response).to be_successful
      expect(quick_preview).to include("Notes")
      expect(quick_preview).to include("No notes recorded")
      expect(quick_preview).not_to include("Save notes")
      expect(quick_preview).not_to include("textarea")
    end

    it "does not list resolved alerts" do
      alert.update!(deleted_at: Time.zone.now)

      get renal_safety_alerts_path

      table_body = Nokogiri::HTML5(response.body).css("table.safety-alerts").text

      expect(response).to be_successful
      expect(table_body).not_to include("Positive MSSA screen")
    end

    it "filters active alerts by rule category" do
      general_category = create(:renal_safety_alert_rule_category, name: "General")
      general_rule = create(
        :renal_safety_alert_rule,
        safety_alert_rule_category: general_category,
        name: "Low haemoglobin"
      )
      create(
        :renal_safety_alert,
        patient: create(:renal_patient, :minimal),
        safety_alert_rule: general_rule,
        rule_name: general_rule.name,
        label: "Hb below threshold"
      )

      get renal_safety_alerts_path, params: { safety_alert_rule_category_id: category.id }

      table_body = Nokogiri::HTML5(response.body).css("table.safety-alerts").text

      expect(response).to be_successful
      expect(table_body).to include("Positive MSSA screen")
      expect(table_body).not_to include("Low haemoglobin")
      expect(active_tab_text).to eq("Active")
    end

    it "filters active alerts by rule" do
      other_rule = create(:renal_safety_alert_rule, name: "Low haemoglobin")
      create(
        :renal_safety_alert,
        patient: create(:renal_patient, :minimal),
        safety_alert_rule: other_rule,
        rule_name: other_rule.name,
        label: "Hb below threshold"
      )

      get renal_safety_alerts_path, params: { safety_alert_rule_id: rule.id }

      table_body = Nokogiri::HTML5(response.body).css("table.safety-alerts").text

      expect(response).to be_successful
      expect(table_body).to include("Positive MSSA screen")
      expect(table_body).not_to include("Low haemoglobin")
      expect(active_tab_text).to eq("Active")
    end
  end

  describe "GET historical" do
    it "lists resolved alerts" do
      user = create(:user, given_name: "Annie", family_name: "Admin")
      alert.update!(deleted_at: Time.zone.now, deleted_by: user, notes: "Reviewed with HD team")

      get historical_renal_safety_alerts_path

      expect(response).to be_successful
      expect(response.body).to include("Active")
      expect(response.body).to include("Historical")
      expect(response.body).to include("BLOGGS, Jane")
      expect(response.body).to include("Positive MSSA screen")
      expect(response.body).to include("Resolved at")
      expect(response.body).to include("Resolved by")
      expect(response.body).to include("Admin, Annie")
      expect(response.body).to include("Reviewed with HD team")
    end

    it "filters resolved alerts by rule category" do
      other_rule = create(:renal_safety_alert_rule, name: "Low haemoglobin")
      create(
        :renal_safety_alert,
        patient: create(:renal_patient, :minimal),
        safety_alert_rule: other_rule,
        rule_name: other_rule.name,
        label: "Hb below threshold",
        deleted_at: Time.zone.now
      )
      alert.update!(deleted_at: Time.zone.now)

      get historical_renal_safety_alerts_path,
          params: { safety_alert_rule_category_id: category.id }

      table_body = Nokogiri::HTML5(response.body).css("table.safety-alerts").text

      expect(response).to be_successful
      expect(table_body).to include("Positive MSSA screen")
      expect(table_body).not_to include("Low haemoglobin")
      expect(active_tab_text).to eq("Historical")
    end
  end

  describe "PATCH update" do
    it "updates notes on an active alert" do
      patch renal_safety_alert_path(alert), params: {
        renal_safety_alert: {
          notes: "Discussed with consultant"
        }
      }

      expect(response).to redirect_to(renal_safety_alerts_path)
      expect(alert.reload.notes).to eq("Discussed with consultant")
      expect(alert.deleted_at).to be_nil
    end

    it "does not update notes on a resolved alert" do
      alert.update!(deleted_at: Time.zone.now, notes: "Original notes")

      patch renal_safety_alert_path(alert), params: {
        renal_safety_alert: {
          notes: "Changed notes"
        }
      }

      expect(response).to redirect_to(historical_renal_safety_alerts_path)
      expect(alert.reload.notes).to eq("Original notes")
    end
  end

  describe "PATCH resolve" do
    it "resolves the alert with notes" do
      user = create(:user, :clinical)
      login_as_with_user(user)

      patch resolve_renal_safety_alert_path(alert), params: {
        renal_safety_alert: {
          notes: "No further action needed"
        }
      }

      expect(response).to redirect_to(renal_safety_alerts_path)
      expect(alert.reload.deleted_at).to be_present
      expect(alert.deleted_by).to eq(user)
      expect(alert.notes).to eq("No further action needed")
    end
  end

  def active_tab_text
    Nokogiri::HTML5(response.body).at_css("dl.sub-nav dd.active").text.strip
  end
end
