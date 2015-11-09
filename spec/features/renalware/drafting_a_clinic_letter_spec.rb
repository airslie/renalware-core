require 'rails_helper'

module Renalware
  feature 'Drafting a clinic letter', js: true do

    background do
      create(:letter_description, text: 'Clinic letter')
      create(:user, first_name: "Aneurin", last_name: "Bevan", signature: "Aneurin Bevan")
      @doctor = create(:doctor)
      @practice = create(:practice)
      @doctor.practices << @practice
      @patient = create(:patient, :with_clinic_visits, doctor: @doctor, practice: @practice)

      @clinic_visit = @patient.clinic_visits.last

      login_as_super_admin
      visit new_clinic_visit_letter_path(clinic_visit_id: @clinic_visit.to_param)
    end

    scenario 'a clinic letter' do
      select 'Clinic letter', from: 'Description'
      select2 'Aneurin Bevan', from: '#letter_author_id'
      fill_in 'Message', with: 'Dear Dr. Goode, I am pleased to inform you that the latest clinic_visit appointment went extremely well'

      click_on 'Save'

      expect(current_path).to eq(patient_letters_path(@patient))

      within('table.letters tbody tr:first-child') do
        expect(page).to have_content('Aneurin Bevan')
        expect(page).to have_content('Clinic letter')
        expect(page).to have_content('draft')
      end
    end
  end
end
