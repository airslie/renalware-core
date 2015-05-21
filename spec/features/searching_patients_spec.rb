require 'rails_helper'

feature 'Searching for a patient' do

  def search_for_patient(query)
    visit '/'
    fill_in 'patient_search_input', with: query
    click_on 'Find Patient'
  end

  def expect_patient_in_results(name, row_number=1)
    within('table.patients') do
      expect(page).to have_css("tbody tr:nth-child(#{row_number}) td[data-heading=Name] a", text: name)
    end
  end

  def dont_expect_patient_in_results(name)
    within('table.patients') do
      expect(page).not_to have_css("tbody tr td[data-heading=Name] a", text: name)
    end
  end

  background do
    create(:patient, surname: 'Jones', forename: 'Jenny')
    create(:patient, surname: 'Smith', forename: 'Will', nhs_number: 'Z111111119')
    create(:patient, surname: 'Walker', forename: 'Johnny',  local_patient_id: '0987654321')
  end

  scenario 'with comma delimited terms it ignores commas' do
    search_for_patient('Jones, J')
    expect_patient_in_results('Jones, J')
  end

  scenario 'by first name it matches the full first name' do
    search_for_patient('Jenny')
    expect_patient_in_results('Jones, J')
  end

  scenario 'by first name it matches a partial first name' do
    search_for_patient('John')
    expect_patient_in_results('Walker, J')
  end

  scenario 'scenario by first name it matches a first name in any case' do
    search_for_patient('joHN')
    expect_patient_in_results('Walker, J')
  end

  scenario 'by surname it matches the full surname' do
    search_for_patient('Jones')
    expect_patient_in_results('Jones, J')
  end

  scenario 'by surname it matches a partial surname' do
    search_for_patient('mith')
    expect_patient_in_results('Smith, W')
  end

  scenario 'by surname it matches a surname in any case' do
    search_for_patient('wALk')
    expect_patient_in_results('Walker, J')
  end

  scenario 'by surname it matches a surname and initial' do
    search_for_patient('Walker J')
    expect_patient_in_results('Walker, J')
  end

  scenario 'by nhs number it matches the exactly' do
    search_for_patient('Z111111119')
    expect_patient_in_results('Smith, W')
  end

  scenario 'by partial nhs number it does not match' do
    search_for_patient('Z1111')
    dont_expect_patient_in_results('Smith, W')
  end

  scenario 'by local id it matches exactly' do
    search_for_patient('0987654321')
    expect_patient_in_results('Walker, J')
  end

  scenario 'by partial local id it does not match' do
    search_for_patient('1234')
    dont_expect_patient_in_results('Walker, J')
  end

end
