require 'rails_helper'

module Renalware
  feature 'Able to view custom error messages on failed validation for an infection organism', js: true do
    background do
      @patient = create(:patient)
      login_as_clinician
      visit new_patient_peritonitis_episode_path(@patient)
    end

    scenario 'a peritonitis episode is saved with invalid values for an infection organism' do
      click_link 'Record a new organism and sensitivity'
      click_on 'Save'

      expect(page).to have_content("Organism can't be blank")
    end
  end

end
