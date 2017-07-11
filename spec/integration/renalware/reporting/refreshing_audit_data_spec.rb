feature "Refreshing audit data", type: :feature, js: true do

  scenario "Manually requesting to refresh audit data" do
    create(:audit, name: "xx", materialized_view_name: "yy")
    login_as_clinician
    visit reporting_audits_path
    ActiveJob::Base.queue_adapter = :test

    within "table.audits" do
      click_on "Refresh Data"
    end

    expect(Renalware::Reporting::RefreshAuditDataJob).to have_been_enqueued
  end
end
