describe "Admin safety alert rule executions" do
  let(:infection_category) { create(:renal_safety_alert_rule_category, name: "Infection") }
  let(:general_category) { create(:renal_safety_alert_rule_category, name: "General") }
  let(:mssa_rule) do
    create(
      :renal_safety_alert_rule,
      safety_alert_rule_category: infection_category,
      name: "Positive MSSA screen",
      function_name: "renalware.positive_mssa_screen"
    )
  end
  let(:hb_rule) do
    create(
      :renal_safety_alert_rule,
      safety_alert_rule_category: general_category,
      name: "Low haemoglobin",
      function_name: "renalware.low_haemoglobin"
    )
  end
  let!(:older_execution) do
    create(
      :renal_safety_alert_rule_execution,
      safety_alert_rule: mssa_rule,
      started_at: 2.days.ago,
      finished_at: 2.days.ago + 3.seconds,
      status: "succeeded",
      matched_count: 3,
      created_count: 2,
      duration_ms: 3000
    )
  end
  let!(:newer_execution) do
    create(
      :renal_safety_alert_rule_execution,
      safety_alert_rule: hb_rule,
      started_at: 1.day.ago,
      finished_at: 1.day.ago + 1.second,
      status: "failed",
      error_message: "Function failed"
    )
  end

  describe "GET index" do
    it "lists executions in reverse chronological order for super admins" do
      get admin_safety_alert_rule_executions_path

      expect(response).to be_successful
      expect(response.body).to include("Positive MSSA screen")
      expect(response.body).to include("Low haemoglobin")
      expect(response.body).to include("Function failed")
      expect(response.body).to include("All categories")
      expect(response.body).to include("All safety rules")
      expect(response.body).to include("<optgroup label=\"General\">")
      expect(response.body).to include("<optgroup label=\"Infection\">")

      row_ids = response.parsed_body
        .css("tbody tr")
        .map { |row| row.css("td").first.text.strip.to_i }

      expect(row_ids).to eq([newer_execution.id, older_execution.id])
    end

    it "filters by safety alert rule" do
      get admin_safety_alert_rule_executions_path, params: { safety_alert_rule_id: mssa_rule.id }

      table_body = response.parsed_body.css("tbody").text

      expect(response).to be_successful
      expect(table_body).to include("Positive MSSA screen")
      expect(table_body).not_to include("Low haemoglobin")
    end

    it "filters by safety alert rule category" do
      get admin_safety_alert_rule_executions_path,
          params: { safety_alert_rule_category_id: infection_category.id }

      table_body = response.parsed_body.css("tbody").text

      expect(response).to be_successful
      expect(table_body).to include("Infection")
      expect(table_body).to include("Positive MSSA screen")
      expect(table_body).not_to include("Low haemoglobin")
    end

    it "is linked from the admin menu for super admins" do
      get admin_dashboard_path

      expect(response).to be_successful
      expect(response.body).to include("Executions")
      expect(response.body).to include(admin_safety_alert_rule_executions_path)
    end

    context "when the user is not a super admin" do
      before { login_as_admin }

      it "redirects to the dashboard" do
        get admin_safety_alert_rule_executions_path

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
