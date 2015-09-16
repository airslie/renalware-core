require 'rails_helper'

module Renalware
  feature 'Previewing a letter', js: true do
    background do
      @patient = create(:patient, :with_problems, :with_meds, :with_clinic_visits)
      login_as_clinician
    end

    scenario 'A simple letter' do
      create(:letter, patient: @patient)
      visit patient_letters_path(@patient)

      within('.letters tbody tr:first-child') do
        click_on 'Preview'
      end

      within('.letter-preview-header') do
        expect(page).to have_content('Status: DRAFT')
        expect(page).to have_content('To: Donald Good, CC: Jack Jones')
        # TODO: this is the factory LetterDescription, it should have letter type traits
        expect(page).to have_content('Title: Clinic letter')
      end

      within('.letter-preview-body') do
        expect(page).to have_content('Dear Dr. Good')
        expect(page).to have_content('I am pleased to report a marked improvement')
        expect(page).to have_content('Aneurin Bevan')
        expect(page).to have_content('Health Minister')
      end
    end

    scenario 'A clinic letter' do
      create(:clinic_letter, patient: @patient)
      visit patient_letters_path(@patient)

      within('.letters tbody tr:first-child') do
        click_on 'Preview'
      end

      within('.letter-preview-header') do
        expect(page).to have_content('Status: DRAFT')
        expect(page).to have_content('To: Donald Good, CC: Jack Jones')
        expect(page).to have_content('Letter type: Clinic Letter')
        expect(page).to have_content('Title: Clinic letter')
        expect(page).to have_content('Clinic date:')
      end

      within('.letter-preview-body') do
        expect(page).to have_content('Problems')
        expect(page).to have_content('Medications')
        expect(page).to have_content('Dear Dr. Good')
        expect(page).to have_content('I am pleased to report a marked improvement')
        expect(page).to have_content('Aneurin Bevan')
        expect(page).to have_content('Health Minister')
      end
    end

  end
end