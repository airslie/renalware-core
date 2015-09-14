require 'rails_helper'

module Renalware
  feature 'Adding CAPD Regimes' do
    background do
      patient = create(:patient)
      create(:bag_type)
      login_as_clinician
      visit pd_info_patient_path(patient)
      click_on 'Add CAPD Regime'
    end

    scenario 'with javascript enabled', js: true do
      select '15', from: 'pd_regime_start_date_3i'
      select 'June', from: 'pd_regime_start_date_2i'
      select '2015', from: 'pd_regime_start_date_1i'

      click_on 'Add Bag'

      select 'CAPD 4 exchanges per day', from: 'Treatment'

      select 'Star Brand, Lucky Brand Green–2.34', from: 'Bag Type'
      fill_in 'Volume', with: '250'

      uncheck 'Sunday'
      uncheck 'Thursday'

      check 'On additional HD'

      click_on 'Save CAPD Regime'

      within('.current-regime') do
        expect(page).to have_content('Regime Start Date: 15/06/2015')
        expect(page).to have_content('CAPD 4 exchanges per day')
        expect(page).to have_content('Bag type: Green–2.34, Volume: 250ml, No. per week: 5, Days: Mon, Tue, Wed, Fri, Sat')
        expect(page).to have_content('On additional HD?: Yes')
      end
    end
  end
end