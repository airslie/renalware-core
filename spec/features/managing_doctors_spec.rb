require 'rails_helper'

feature 'Managing Doctors', js: true do

  include Select2SpecHelper

  background do
    @athena_medical_centre = create(:practice, name: 'Athena Medical Centre',
           address: create(:address, street_1: '21 Atherden Road', postcode: 'E5 0QP'))
    @median_road_surgery = create(:practice, name: 'Median Road Surgery',
           address: create(:address, street_1: '28 Median Road', postcode: 'E5 0PL'))
    @lower_clapton_group_practice = create(:practice, name: 'Lower Clapton Group Practice',
           address: create(:address, street_1: '32 Lower Clapton Road', postcode: 'E5 0PQ'))

    login_as_super_admin
  end

  scenario 'Adding a new Doctor' do
    visit doctors_path

    click_on 'Add Doctor'

    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Merrill'
    fill_in 'Email', with: 'john.merrill@nhs.net'
    fill_in 'Code', with: 'GP12345'
    select 'GP', from: 'Practitioner type'
    select2 'Median Road Surgery', '#doctor_practice_ids'

    click_on 'Save'

    within('table.doctors') do
      expect(page).to have_content('John Merrill')
      expect(page).to have_content('GP12345')
    end
  end

  scenario 'Adding a foreign Doctor' do
    visit doctors_path

    click_on 'Add Doctor'

    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Merrill'
    fill_in 'Email', with: 'john.merrill@nhs.net'
    fill_in 'Code', with: 'GP12345'
    select 'GP', from: 'Practitioner type'

    click_on 'Alternative address'

    fill_in 'Street 1', with: '123 Sunset Bvd.'

    select 'United States', from: 'Country'

    click_on 'Save'

    within('table.doctors') do
      expect(page).to have_content('John Merrill')
      expect(page).to have_content('GP12345')
      expect(page).to have_content('123 Sunset Bvd.')
    end
  end

  scenario 'Submitting an invalid address' do
    visit new_doctor_path

    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Merrill'
    fill_in 'Email', with: 'john.merrill@nhs.net'
    fill_in 'Code', with: 'GP12345'
    select 'GP', from: 'Practitioner type'

    click_on 'Alternative address'

    fill_in 'Street 1', with: '123 North Road'
    select 'United Kingdom', from: 'Country'

    click_on 'Save'

    expect(page).to have_content("Address postcode can't be blank for UK address")
  end


  scenario 'Submitting invalid details' do
    visit new_doctor_path
    click_on 'Save'

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Address or practice must be present")
  end

  scenario 'Editing an existing Doctor' do
    doctor = create(:doctor, email: 'do.good@nhs.net', practices: [@athena_medical_centre])

    visit doctors_path

    within('table.doctors tbody tr:first-child') do
      click_on 'Edit'
    end

    fill_in 'Email', with: 'john.merrill@nhs.net'
    select2 'Median Road Surgery', '#doctor_practice_ids'

    click_on 'Update'

    within('table.doctors') do
      expect(page).to have_content('john.merrill@nhs.net')
      expect(page).to have_link('Median Road Surgery')
    end
  end

  scenario 'Deleting a Doctor' do
    doctor = create(:doctor,
                    first_name: 'John',
                    last_name: 'Merrill',
                    email: 'john.merrill@nhs.net',
                    practices: [@athena_medical_centre])

    visit doctors_path

    within('table.doctors tbody tr:first-child') do
      click_on 'Delete'
    end

    within('table.doctors') do
      expect(page).not_to have_content('John Merrill')
      expect(page).not_to have_content('john.merrill@nhs.net')
      expect(page).not_to have_link('Median Road Surgery')
    end
  end
end
