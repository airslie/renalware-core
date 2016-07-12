require 'rails_helper'

module Renalware
  feature 'Validate for at least one bag per PD regime', js: true do
    background do
      @patient = create(:patient)
      login_as_clinician
      visit patient_pd_dashboard_path(@patient)
    end

    scenario 'creating a CAPD regime without a bag should fail validation' do
      click_link 'Add CAPD Regime'

      select 'CAPD 3 exchanges per day', from: 'Treatment'

      click_on "Save"

      expect(page).to have_content('PD regime must be assigned at least one bag')
    end
  end
end
