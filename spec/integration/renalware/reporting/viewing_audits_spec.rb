require "rails_helper"

feature "Viewing audits", type: :feature, js: true do

  scenario "viewing a list of audits" do
    audit = create(:audit, name: "XX")
    login_as_clinician

    visit reporting_audits_path

    expect(page).to have_content(audit.name)
  end

  scenario "viewing an audit" do
    audit = create(:audit, name: "XX", description: "A short description")
    login_as_clinician
    allow(Renalware::Reporting::GenerateAuditJson).to receive(:call).and_return("{ data: [] }")

    visit reporting_audit_path(audit)

    expect(page).to have_content(audit.name)
    expect(page).to have_content(audit.description)
    # TODO: set up some data and audit with config and test that data tables renders
  end
end
