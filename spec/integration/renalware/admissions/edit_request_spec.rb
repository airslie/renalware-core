require "rails_helper"

feature "Update Admission Request", type: :feature, js: true do
  include AjaxHelpers

  scenario "Edit the request in a modal and updated it" do
    user = login_as_clinical
    request = create(:admissions_request, by: user)

    visit admissions_requests_path

    within "#admissions_request_#{request.id}" do
      click_on "Edit"
    end

    wait_for_ajax

    fill_in "Notes", with: "more notes"
    click_on "Save"

    wait_for_ajax

    within "#admissions_request_#{request.id}" do
      expect(page).to have_content("more notes")
    end
  end
end
