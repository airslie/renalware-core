require 'rails_helper'

feature 'Drafting a letter', js: true do
  include Select2SpecHelper
  include SelectDate

  background do
    create(:letter_description, text: 'Clinic letter')
    @doctor = create(:doctor)
    @practice = create(:practice)
    @doctor.practices << @practice
    @patient = create(:patient, doctor: @doctor, practice: @practice)

    login_as_super_admin
    visit new_patient_letter_path(@patient)
  end

  scenario 'a clinic letter' do
    select 'Clinic letter', from: 'Description'
    select2 'Aneurin Bevan', '#letter_author_id'
    select 'clinic', from:  'Letter type'
    select_date '2015,April,1', from: 'Clinic date'
    fill_in 'Message', with: 'Dear Dr. Goode, I am pleased to inform you that the latest clinic appointment went extremely well'

    click_on 'Save'

    expect(current_path).to eq(patient_letters_path(@patient))

    within('table.letters tbody tr:first-child') do
      expect(page).to have_content('Aneurin Bevan')
      expect(page).to have_content('Clinic letter')
      expect(page).to have_content('draft')
    end
  end

  scenario 'a death notification' do

  end

  scenario 'a discharge notification' do

  end

  scenario 'a simple letter' do

  end
end
