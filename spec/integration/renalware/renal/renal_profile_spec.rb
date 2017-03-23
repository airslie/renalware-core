require "rails_helper"

RSpec.describe "Renal Profile (ESRF/Comorbidities", type: :feature do

  describe "GET #show" do
    it "updating the renal profile" do
      esrf_date = "24-Mar-2017"
      patient = Renalware::Renal.cast_patient(create(:patient))
      profile = patient.build_profile
      profile.esrf_on = esrf_date
      profile.save!

      login_as_clinician

      visit patient_path(patient)
      within ".side-nav" do
        click_on "ESRF/Comorbidities"
      end

      # Renal profile #show
      expect(page.status_code).to eq(200)
      expect(page.current_path).to eq(patient_renal_profile_path(patient))
      expect(page).to have_content(esrf_date)

      within ".page-actions" do
        click_on "Edit"
      end

      # Renal profile #edit
      expect(page.status_code).to eq(200)
      expect(page.current_path).to eq(edit_patient_renal_profile_path(patient))

      updated_esrf_date = "25-Mar-2016"
      fill_in "ESRF on", with: updated_esrf_date
      within page.first(".form-actions") do
        click_on "Save"
      end

      # Renal profile #show
      expect(page.status_code).to eq(200)
      expect(page.current_path).to eq(patient_renal_profile_path(patient))
      expect(page).to have_content(updated_esrf_date)
    end
  end
end
