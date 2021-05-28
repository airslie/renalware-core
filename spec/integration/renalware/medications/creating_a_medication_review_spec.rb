# frozen_string_literal: true

require "rails_helper"

describe "Creating a medication review on the prescriptions page", type: :system, js: true do
  it "after accepting an alert it adds the latest review to the page using ajax" do
    create(:medication_review_event_type)
    user = login_as_clinical
    patient = create(:patient, by: user)

    visit patient_prescriptions_path(
      patient,
      treatable_type: patient.class.to_s,
      treatable_id: patient
    )

    expect(page).not_to have_css(".medication-review", wait: 0)

    accept_alert do
      click_on "Medication Review"
    end

    expect(page).to have_css(".medication-review")
    # NB: content tests handed in LatestReviewComponent specs
  end
end
