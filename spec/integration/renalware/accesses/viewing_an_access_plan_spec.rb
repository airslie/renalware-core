require "rails_helper"

feature "Viewing an Access Plan", type: :feature do
  include DateHelpers

  scenario "A clinician views a patient's Access Plan" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    plan = create(:access_plan, patient: patient, by: user)

    visit patient_accesses_dashboard_path(patient)

    within ".access-plans" do
      click_on "View"
    end

    visit patient_accesses_plan_path(patient, plan)

    expect(page).to have_content(todays_date)
    expect(page).to have_content(user.to_s)
    expect(page).to have_content(plan.notes)
    expect(page).to have_content(plan.plan_type.to_s)
  end
end
