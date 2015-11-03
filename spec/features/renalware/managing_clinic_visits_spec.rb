require 'rails_helper'

module Renalware
  feature 'Managing clinic visits' do
    background do
      @patient = create(:patient)
      login_as_clinician
    end

    scenario 'Adding a clinic visit' do
      visit new_patient_clinic_visit_path(@patient)

      fill_in 'Height', with: '1.78'
      fill_in 'Weight', with: '82.5'
      fill_in 'Blood Pressure', with: '110/75'

      click_on 'Save'

      within('.clinics tbody tr:first-child') do
        within('.bmi') do
          expect(page).to have_content('26.04')
        end
        within('.bp') do
          expect(page).to have_content('110/75')
        end
      end
    end

    scenario 'Editing a clinic visit' do
      clinic_visit = create(:clinic_visit)
      @patient.clinic_visits << clinic_visit

      visit edit_patient_clinic_visit_path(patient_id: @patient.to_param, id: clinic_visit.to_param)

      fill_in 'Height', with: '1.62'
      fill_in 'Weight', with: '95'
      fill_in 'Blood Pressure', with: '128/95'

      click_on 'Update'

      within('.clinics tbody tr:first-child') do
        within('.bmi') do
          expect(page).to have_content('36.2')
        end
        within('.bp') do
          expect(page).to have_content('128/95')
        end
      end

    end
  end
end
