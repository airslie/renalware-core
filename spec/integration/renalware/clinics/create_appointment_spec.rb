# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Create new appointment manually (not via HL7 message)", type: :system, js: true do
  context "with valid inputs" do
    it "creates a new clinic appointment" do
      user = login_as_clinical
      patient = Renalware::Clinics.cast_patient(create(:patient, by: user))
      clinic = create(:clinic)

      visit appointments_path

      within(".page-heading") do
        click_on "Add"
      end

      expect(page).to have_current_path(new_appointment_path)
      expect(page).to have_content("Clinic Appointments / New")

      within(".new_clinics_appointment") do
        select2(
          patient.to_s(:long),
          css: "#patient-select2",
          search: true
        )

        select clinic.name, from: "Clinic"
        fill_in "Starts at", with: "08-Aug-2018"
        click_on "Create"
      end

      expect(page).not_to have_content("Clinic Appointments / New")

      within("#appointments") do
        expect(page).to have_content(patient.to_s)
        expect(page).to have_content(clinic.to_s)
      end
    end
  end
end
