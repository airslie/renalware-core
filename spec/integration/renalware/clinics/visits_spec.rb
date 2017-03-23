require "rails_helper"

RSpec.describe "Global Clinic Visits list", type: :feature do

  describe "GET index" do

    it "responds successfully" do
      login_as_clinician
      patient = Renalware::Clinics.cast_patient(create(:patient))
      create(:clinic_visit, patient: patient)

      visit clinic_visits_path

      expect(page.status_code).to eq(200)
      expect(page).to have_content(patient.nhs_number)

    end
  end
end
