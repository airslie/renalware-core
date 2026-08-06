describe "Primary navigation" do
  around do |example|
    original_value = Renalware.config.use_new_primary_navigation
    original_feedback_value = Renalware.config.display_feedback_button_in_navbar
    original_new_mdms_value = Renalware.config.enable_new_mdms
    Renalware::Patients::MDMMenu.cached_items = nil
    example.run
    Renalware.config.use_new_primary_navigation = original_value
    Renalware.config.display_feedback_button_in_navbar = original_feedback_value
    Renalware.config.enable_new_mdms = original_new_mdms_value
    Renalware::Patients::MDMMenu.cached_items = nil
  end

  it "uses the primary navigation by default" do
    get dashboard_path

    expect(response).to be_successful
    expect(response.body).to include("rw-primary-nav")
    expect(response.body).to include("primary-navigation-menu")
    expect(response.body).not_to include("top-menu-bar")
  end

  it "uses the existing Foundation top-bar when disabled" do
    Renalware.config.use_new_primary_navigation = false
    get dashboard_path

    expect(response).to be_successful
    expect(response.body).to include("top-menu-bar")
    expect(response.body).not_to include("rw-primary-nav")
  end

  it "uses the opt-in primary navigation when enabled" do
    Renalware.config.use_new_primary_navigation = true
    Renalware.config.display_feedback_button_in_navbar = true

    get dashboard_path

    expect(response).to be_successful
    expect(response.body).to include("rw-primary-nav")
    expect(response.body).to include("primary-navigation-menu")
    expect(response.body).not_to include("top-menu-bar")
    user_menu_label = @current_user.username.capitalize
    expect(response.body).to include(">#{user_menu_label}<")
    expect(response.body.index(user_menu_label)).to be < response.body.index(">Renal<")
    expect(response.body.index(">Admin<")).to be < response.body.index(">Feedback<")
    expect(response.body.index(">Feedback<")).to be < response.body.index(">Help<")
  end

  it "uses main application paths when rendered inside an engine" do
    Renalware.config.use_new_primary_navigation = true

    get reporting.reports_path

    expect(response).to be_successful
    expect(response.body).to include(%(href="/appointments"))
    expect(response.body).not_to include(%(href="/reporting/appointments"))
  end

  it "separates static and beta MDM links" do
    Renalware.config.use_new_primary_navigation = true
    Renalware.config.enable_new_mdms = true
    create(:view_metadata, category: "mdm", scope: "dietetics", title: "Dietetic MDM")

    get dashboard_path

    expect(response).to be_successful
    expect(response.body.index(">AKCC<")).to be < response.body.index("Beta MDMs")
    expect(response.body.index("Beta MDMs")).to be < response.body.index(">Dietetic MDM<")
  end
end
