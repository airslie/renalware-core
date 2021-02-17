# frozen_string_literal: true

require "rails_helper"
describe "Create new appointment manually (not via HL7 message)", type: :system, js: true do
  context "with valid inputs" do
    it "creates a new clinic appointment" do
      user = login_as_clinical
      patient = Renalware::Clinics.cast_patient(create(:patient, by: user))
      clinic = create(:clinic, name: "Clinic A")

      visit appointments_path

      within(".page-heading") do
        click_on t("btn.add")
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
        fill_in "Outcome notes", with: "Outcome notes"
        fill_in "DNA notes", with: "DNA notes"
        click_on t("btn.create")
      end

      expect(page).not_to have_content("Clinic Appointments / New")

      within("#appointments") do
        expect(page).to have_content(patient.to_s)
        expect(page).to have_content(clinic.to_s)
      end

      appointment = Renalware::Clinics::Appointment.last
      expect(appointment).to have_attributes(
        outcome_notes: "Outcome notes",
        dna_notes: "DNA notes"
      )
    end
  end
end
