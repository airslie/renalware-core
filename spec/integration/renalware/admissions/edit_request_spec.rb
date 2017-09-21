require "rails_helper"

feature "Remove Admission Request", type: :feature, js: true do
  include AjaxHelpers

  scenario "Clicking remove soft delete the request and removes it from the list" do
    user = login_as_clinician

    request = create(:admissions_request, updated_by: user, created_by: user)

    visit admissions_requests_path

    within "#admissions_request_#{request.id}" do
      click_on "Edit"
    end

    wait_for_ajax
    expect(all(:css, "tbody tr").count).to eq(0)

  end
end
