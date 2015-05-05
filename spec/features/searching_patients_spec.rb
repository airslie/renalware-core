require 'rails_helper'

describe 'A clinician searches for a patient' do

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


  before do
    create(:patient, surname: 'Jones', forename: 'Jenny')
    create(:patient, surname: 'Smith', forename: 'Will', nhs_number: 'Z111111119')
    create(:patient, surname: 'Walker', forename: 'Johnny',  local_patient_id: '0987654321')
  end

  context 'with comma delimited terms' do
    it 'ignores commas' do
      search_for_patient('Jones, J')
      expect_patient_in_results('Jones, J')
    end
  end

  context 'by first name' do
    it 'matches the full first name' do
      search_for_patient('Jenny')
      expect_patient_in_results('Jones, J')
    end
    it 'matches a partial first name' do
      search_for_patient('John')
      expect_patient_in_results('Walker, J')
    end
    it 'matches a first name in any case' do
      search_for_patient('joHN')
      expect_patient_in_results('Walker, J')
    end
    it 'matches a first name and initial' do
      search_for_patient('Johnny W')
      expect_patient_in_results('Walker, J')
    end
  end

  context 'by surname' do
    it 'matches the full surname' do
      search_for_patient('Jones')
      expect_patient_in_results('Jones, J')
    end
    it 'matches a partial surname' do
      search_for_patient('mith')
      expect_patient_in_results('Smith, W')
    end
    it 'matches a surname in any case' do
      search_for_patient('wALk')
      expect_patient_in_results('Walker, J')
    end
    it 'matches a surname and initial' do
      search_for_patient('Walker J')
      expect_patient_in_results('Walker, J')
    end
  end

  context 'by nhs number' do
    it 'matches the exactly' do
      search_for_patient('Z111111119')
      expect_patient_in_results('Smith, W')
    end
    it 'does not match partially' do
      search_for_patient('Z1111')
      dont_expect_patient_in_results('Smith, W')
    end
  end

  context 'by local id' do
    it 'matches exactly' do
      search_for_patient('0987654321')
      expect_patient_in_results('Walker, J')
    end
    it 'does not match partially' do
      search_for_patient('1234')
      dont_expect_patient_in_results('Walker, J')
    end
  end
end
