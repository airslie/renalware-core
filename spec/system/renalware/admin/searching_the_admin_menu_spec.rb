describe "Searching the admin menu", :js do
  it "filters authorized items while retaining their section context" do
    login_as_super_admin
    visit admin_dashboard_path

    within ".admin-menu" do
      fill_in "Search admin menu", with: "logs"

      visible_links = all(
        "[data-admin-menu-filter-target='item']:not([hidden]) a",
        visible: true
      ).map(&:text)

      expect(visible_links).to eq(["Transmission Logs", "Logs", "API Logs", "UKRDC Logs"])
      expect(page).to have_css(".admin-menu-search__status", text: "4 results")
      expect(page).to have_css(".admin-menu__section:not([hidden]) summary", text: "HD")
      expect(page).to have_css(".admin-menu__section:not([hidden]) summary", text: "Feeds")
      expect(page).to have_css(".admin-menu__section:not([hidden]) summary", text: "System")
      expect(page).to have_css(
        "[data-admin-menu-filter-target='item'][hidden]",
        text: "Users",
        visible: :all
      )
    end
  end

  it "supports multiple terms, no-results feedback, and clearing" do
    login_as_super_admin
    visit admin_dashboard_path

    within ".admin-menu" do
      fill_in "Search admin menu", with: "trans log"
      expect(page).to have_link("Transmission Logs")
      expect(page).to have_no_link("API Logs")

      fill_in "Search admin menu", with: "definitely missing"
      expect(page).to have_text("No matching menu items")

      find("button[aria-label='Clear admin menu search']").click
      expect(page).to have_field("Search admin menu", with: "")
      expect(page).to have_link("Users", visible: :all)
      expect(page).to have_no_css(".admin-menu-search__status", visible: :visible)
    end
  end
end
