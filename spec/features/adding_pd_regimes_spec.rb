require 'rails_helper'

feature 'Adding PD Regimes' do
  background do
    patient = create(:patient)
    create(:bag_type)
    login_as_clinician
    visit new_patient_pd_regime_path(patient)
  end

  scenario 'with javascript enabled', js: true do
    select '15', from: 'pd_regime_start_date_3i'
    select 'June', from: 'pd_regime_start_date_2i'
    select '2015', from: 'pd_regime_start_date_1i'

    click_on 'Add Bag'

    select 'Star Brand, Lucky Brand Green–2.34', from: 'Bag Type'
    fill_in 'Volume', with: '2'
    select '5', from: 'Per week'
    check 'Monday'
    check 'Tuesday'
    check 'Wednesday'
    check 'Friday'
    check 'Saturday'

    check 'On additional HD'

    click_on 'Save PD Regime'

    within('.current-regime') do
      expect(page).to have_content('Regime Start Date: 15/06/2015')
      expect(page).to have_content('Bag type: Green–2.34, Volume: 2ml, No. per week: 5, Days: Mon, Tue, Wed, Fri, Sat')
      expect(page).to have_content('On additional HD: Yes')
    end
  end
end
