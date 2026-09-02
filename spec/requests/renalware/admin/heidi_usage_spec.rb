describe "Admin Heidi usage" do
  around do |example|
    original = Renalware.config.heidi_enabled
    example.run
  ensure
    Renalware.config.heidi_enabled = original
  end

  before { travel_to(Time.zone.parse("2026-09-15 10:30")) }

  describe "GET show" do
    it "shows monthly Heidi usage and is linked from the admin menu" do
      create(:heidi_session, created_at: "2026-09-01 09:00")
      create(:heidi_session, created_at: "2026-09-02 09:00")

      get admin_heidi_usage_path

      expect(response).to be_successful
      expect(response.body).to include("Heidi Usage")
      expect(response.body).to include("September 2026")
      expect(response.parsed_body.css("tbody tr").first.text).to include("2")

      Renalware.config.heidi_enabled = true
      get admin_dashboard_path

      expect(response.body).to include("Heidi Usage")
      expect(response.body).to include(admin_heidi_usage_path)
    end
  end

  context "when the user is clinical" do
    before { login_as_clinical }

    it "redirects to the dashboard" do
      get admin_heidi_usage_path

      expect(response).to redirect_to(dashboard_path)
    end
  end
end
