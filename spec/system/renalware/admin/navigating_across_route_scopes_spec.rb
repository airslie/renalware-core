describe "Navigating the admin menu across route scopes", :js do
  it "returns from the hospitals engine to a main-app admin page" do
    login_as_super_admin
    visit admin_dashboard_path

    within ".side-nav--admin" do
      find("summary", text: "System").click
      click_on "Hospital Centres"
    end

    within ".side-nav--admin" do
      find("summary", text: "Pathology").click
      click_on "Code Groups"
    end

    expect(page).to have_current_path(pathology_code_groups_path)
  end
end
