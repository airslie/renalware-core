# frozen_string_literal: true

require "rails_helper"

feature "Remove Admission Request", type: :feature, js: true do
  include AjaxHelpers

  scenario "Clicking remove soft delete the request and removes it from the list" do
    user = login_as_clinical
    request = create(:admissions_request, by: user)

    visit admissions_requests_path

    within "#admissions_request_#{request.id}" do
      find(:css, ".remove").click
    end
    wait_for_ajax
    expect(all(:css, "table.admissions_requests tbody tr").count).to eq(0)
  end
end
