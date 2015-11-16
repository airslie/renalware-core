require "rails_helper"

module Renalware
  feature "Managing clinic visits" do
    background do
      @patient = create(:patient)
      create(:clinic_type, name: "Access")
      create(:clinic_type, name: "Anaemia")
      login_as_clinician
    end

    scenario "Adding a clinic visit" do
      visit new_patient_clinic_visit_path(@patient)

      fill_in "Date", with: "20-07-#{Date.current.year} 10:45"
      select "Access", from: "Clinic type"
      fill_in "Height", with: "1.78"
      fill_in "Weight", with: "82.5"
      fill_in "Blood Pressure", with: "110/75"

      click_on "Save"

      within(".clinics tbody tr:first-child") do
        within(".date-time") do
          expect(page).to have_content("20/07/#{Date.current.year}, 10:45")
        end
        within(".bmi") do
          expect(page).to have_content("26.04")
        end
        within(".bp") do
          expect(page).to have_content("110/75")
        end
        within(".clinic-type") do
          expect(page).to have_content("Access")
        end
        within(".created-by") do
          expect(page).to have_content("Bevan")
        end
      end
    end

    scenario "Editing a clinic visit" do
      clinic_visit = create(:clinic_visit, patient: @patient)

      visit edit_patient_clinic_visit_path(patient_id: @patient.to_param,
                                           id: clinic_visit.to_param)

      select "Anaemia", from: "Clinic type"
      fill_in "Height", with: "1.62"
      fill_in "Weight", with: "95"
      fill_in "Blood Pressure", with: "128/95"

      click_on "Update"

      within(".clinics tbody tr:first-child") do
        within(".bmi") do
          expect(page).to have_content("36.2")
        end
        within(".bp") do
          expect(page).to have_content("128/95")
        end
        within(".clinic-type") do
          expect(page).to have_content("Anaemia")
        end
      end

    end
  end
end
