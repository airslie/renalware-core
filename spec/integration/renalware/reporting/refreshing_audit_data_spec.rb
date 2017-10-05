require "rails_helper"

feature "Refreshing audit data", type: :feature, js: true do

  scenario "Manually requesting to refresh audit data" do
    login_as_clinician
    create(:audit, name: "xx", view_name: "yy")
    visit reporting_audits_path
    ActiveJob::Base.queue_adapter = :test

    within "table.audits" do
      click_on "Refresh Data"
    end

    expect(page.status_code).to eq(200)
    pending
    expect(Renalware::Reporting::RefreshAuditDataJob).to have_been_enqueued
  end
end
