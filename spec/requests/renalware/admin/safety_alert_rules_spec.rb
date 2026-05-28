describe "Admin safety alert rules" do
  include ActiveJob::TestHelper

  after do
    ActiveRecord::Base.connection.execute(
      "DROP FUNCTION IF EXISTS renalware.positive_mssa_screen()"
    )
    clear_enqueued_jobs
  end

  let(:infection_category) { create(:renal_safety_alert_rule_category, name: "Infection") }
  let(:general_category) { create(:renal_safety_alert_rule_category, name: "General") }
  let!(:enabled_rule) do
    create(
      :renal_safety_alert_rule,
      safety_alert_rule_category: infection_category,
      name: "Positive MSSA screen",
      function_name: "renalware.positive_mssa_screen",
      enabled: true
    )
  end
  let!(:disabled_rule) do
    create(
      :renal_safety_alert_rule,
      safety_alert_rule_category: general_category,
      name: "Low haemoglobin",
      function_name: "renalware.low_haemoglobin",
      enabled: false
    )
  end

  describe "GET index" do
    it "lists rule attributes for super admins" do
      get admin_safety_alert_rules_path

      expect(response).to be_successful
      expect(response.body).to include("Positive MSSA screen")
      expect(response.body).to include("Infection")
      expect(response.body).to include("renalware.positive_mssa_screen")
      expect(response.body).to include("Low haemoglobin")
      expect(response.body).to include("General")
      expect(response.body).to include("renalware.low_haemoglobin")
      expect(response.body).to include("Disable")
      expect(response.body).to include("Enable")
      expect(response.body).to include('data-confirm="Are you sure?"')
    end

    it "filters by category" do
      get admin_safety_alert_rules_path,
          params: { safety_alert_rule_category_id: infection_category.id }

      table_body = response.parsed_body.css("table").text

      expect(response).to be_successful
      expect(response.body).to include("All categories")
      expect(table_body).to include("Infection")
      expect(table_body).to include("Positive MSSA screen")
      expect(table_body).not_to include("Low haemoglobin")
    end

    it "shows a confirmed command to queue rule execution" do
      get admin_safety_alert_rules_path

      expect(response).to be_successful
      expect(response.body).to include("Run now")
      expect(response.body).to include(run_admin_safety_alert_rule_path(enabled_rule))
      expect(response.body).to include("Are you sure you want to run this rule now?")
    end

    it "shows read-only SQL function definitions in expandable rows" do
      ActiveRecord::Base.connection.execute(<<~SQL.squish)
        CREATE OR REPLACE FUNCTION renalware.positive_mssa_screen()
        RETURNS TABLE(patient_id integer, label text, metadata jsonb)
        LANGUAGE sql
        STABLE
        AS $$
          SELECT 1, 'Positive MSSA screen'::text, '{}'::jsonb
        $$;
      SQL

      get admin_safety_alert_rules_path

      expect(response).to be_successful
      expect(response.body).to include("View SQL")
      expect(response.body).to include("CREATE OR REPLACE FUNCTION renalware.positive_mssa_screen")
    end

    it "is linked from the admin menu for super admins" do
      get admin_dashboard_path

      expect(response).to be_successful
      within(".safety-alerts") do
        expect(response.body).to include("Safety Alert Rules")
        expect(response.body).to include(admin_safety_alert_rules_path)
      end
    end

    context "when the user is not a super admin" do
      before { login_as_admin }

      it "redirects to the dashboard" do
        get admin_safety_alert_rules_path

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "PATCH enable" do
    it "enables a rule" do
      patch enable_admin_safety_alert_rule_path(disabled_rule)

      expect(response).to redirect_to(admin_safety_alert_rules_path)
      expect(disabled_rule.reload).to be_enabled
    end
  end

  describe "PATCH disable" do
    it "disables a rule" do
      patch disable_admin_safety_alert_rule_path(enabled_rule)

      expect(response).to redirect_to(admin_safety_alert_rules_path)
      expect(enabled_rule.reload).not_to be_enabled
    end
  end

  describe "POST run" do
    it "queues a rule execution job" do
      expect {
        post run_admin_safety_alert_rule_path(disabled_rule)
      }.to have_enqueued_job(Renalware::Renal::RunSafetyAlertRulesJob).with(disabled_rule.id)

      expect(response).to redirect_to(admin_safety_alert_rules_path)
      expect(flash[:notice]).to eq("Safety alert rule queued")
    end
  end
end
