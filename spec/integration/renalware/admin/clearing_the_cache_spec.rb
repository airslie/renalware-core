require "rails_helper"

feature "Clearing the Rails cache" do
  scenario "A super admin clears the admin cache" do
    login_as_super_admin
    visit dashboard_path

    within "#top-menu-bar" do
      click_on "Admin"
      click_on "Cache"
    end

    expect(page).to have_current_path(admin_cache_path)

    allow(Rails.cache).to receive(:clear)

    click_on "Clear the Application Cache"

    expect(Rails.cache).to have_received(:clear)
  end
end
