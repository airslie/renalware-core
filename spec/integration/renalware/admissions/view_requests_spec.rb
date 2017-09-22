require "rails_helper"

feature "View Admission Request", type: :feature do
  scenario "Use the top menu to navigate to the list of admission requests" do
    login_as_clinician
    visit dashboard_path

    within "#top-menu-bar" do
      click_on "Patients"
      click_on "Admission Requests"
    end

    expect(page.current_path).to eq(admissions_requests_path)
  end
end
