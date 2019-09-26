# frozen_string_literal: true

require "rails_helper"

describe "Add a prescription using drug chosen from a category", type: :system, js: true do
  it do
    form = Pages::Medications::PrescriptionForm.new
    user = login_as_clinical
    patient = create(:patient, by: user)
    create(:drug, :esa, name: "Blue Pill")
    create(:medication_route, :po)

    visit patient_prescriptions_path(
      patient,
      treatable_type: patient.class.to_s,
      treatable_id: patient
    )

    within ".page-actions" do
      click_on "Add"
    end

    form.drug_type = "ESA"
    form.drug = "Blue Pill"
    form.drug_dose = 1
    form.dose_unit = "ampoule"
    form.route = "PO"
    form.frequency = "abc"
    form.prescribed_on = "26-Sep-2019"
    form.provider = "GP"
    form.save

    within "#prescriptions" do
      expect(page).to have_content("Current")
      expect(page).to have_content("Historical")
      expect(page).to have_content("Blue Pill")
    end
    expect(page).not_to have_content("Drug can't be blank")
  end
end
