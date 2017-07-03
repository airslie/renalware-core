require "rails_helper"

feature "Managing audits", type: :feature do
  scenario "Updating an audit" do
    audit = create(:audit, name: "XX")
    login_as_clinician
    visit reporting_audits_path

    within "table.audits" do
      click_on "Edit"
    end

    expect(page.current_path).to eq(edit_reporting_audit_path(audit))
    display_config = "{test: 1}"
    fill_in t_audit(:name), with: "Changed name"
    fill_in t_audit(:description), with: "Desc"
    fill_in t_audit(:display_configuration), with: display_config
    fill_in t_audit(:refresh_schedule), with: "5 0 * * *"
    click_on "Save"

    expect(page.current_path).to eq(reporting_audits_path)

    audit.reload

    expect(audit.name).to eq("Changed name")
    expect(audit.description).to eq("Desc")
    expect(audit.display_configuration).to eq(display_config)
    expect(audit.refresh_schedule).to eq("5 0 * * *")
  end

  def t_audit(key, scope: "activerecord.attributes.renalware/reporting/audit")
    I18n.t(key.to_s, scope: scope)
  end
end
