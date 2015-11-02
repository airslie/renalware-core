require 'rails_helper'

module Renalware
  feature 'Able to view custom error messages on failed validation for a medication', js: true do
    background do
      @patient = create(:patient)
      login_as_clinician
      visit patient_medications_path(@patient)
    end

    scenario 'a medication is saved with invalid values' do
      click_link 'Add a new medication'
      click_on 'Save Medication'

      expect(page).to have_content("Medication to be administered can't be blank")
      expect(page).to have_content("Medication's dose can't be blank")
      expect(page).to have_content("Medication's route can't be blank")
      expect(page).to have_content("Medication's frequency & duration can't be blank")
      expect(page).to have_content("Medication's prescribed date can't be blank")
    end
  end
end
