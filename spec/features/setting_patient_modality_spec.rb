require 'rails_helper'

describe 'A clinician sets a patient modality' do
  before do
    @patient = create(:patient)
    @modality = create(:modality, :pd_to_haemo)
    login_as_super_admin

    visit new_patient_modality_path(@patient)

    within '.modality-form' do
      select 'CAPD (disconnect)', from: 'modality-code-select'
      select 'Haemodialysis To PD', from: 'Type of Change'
      select 'Patient / partner choice', from: 'Reason for Change'
      select '2015', from: 'modality_start_date_1i'
      select 'April', from: 'modality_start_date_2i'
      select '17', from: 'modality_start_date_3i'
      fill_in 'Notes', with: 'Adding modality for patient'
      click_button 'Save Modality'
    end
  end

  it 'takes the clinician to the patient modality history' do
    expect(current_path).to eq(patient_modalities_path(@patient))
    expect(page).to have_content('Patient Modality')
  end

  context 'where the patient has no existng modality' do
    it 'adds a new modality for the patient' do
      within('.main-content') do
        within('table tr:nth-child(2)') do
          expect(page).to have_css('td:first-child', text: 'CAPD (disconnect)')
          expect(page).to have_css('td:nth-child(2)', text: 'Adding modality for patient')
        end
      end
    end
  end
  context 'where the patient has an existing modality' do
    it 'supercedes the existing modality with a new one' do
      expect(page).to have_content('Patient Modality')
      within('table tr:nth-child(2)') do
        expect(page).to have_css('td:first-child', text: 'CAPD (disconnect)')
        expect(page).to have_css('td:nth-child(2)', text: 'Adding modality for patient')
      end
    end
  end
end
