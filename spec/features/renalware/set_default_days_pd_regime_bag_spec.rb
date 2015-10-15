require 'rails_helper'

module Renalware
  feature "pd regime bag's days assigned are by default set all to true"  do

    background do
      @patient = create(:patient)
      @pd_regime_bag_1 = PDRegimeBag.new
      @pd_regime_bag_2 = build(:pd_regime_bag,
                          sunday: true,
                          monday: false,
                          tuesday: true,
                          wednesday: false,
                          thursday: false,
                          friday: true,
                          saturday: false
                        )
      login_as_clinician
    end

    scenario 'when creating a new pd regime bag, all days of week set by default as true' do
      expect(@pd_regime_bag_1.monday).to eq(true)
      expect(@pd_regime_bag_1.tuesday).to eq(true)
      expect(@pd_regime_bag_1.wednesday).to eq(true)
      expect(@pd_regime_bag_1.thursday).to eq(true)
      expect(@pd_regime_bag_1.friday).to eq(true)
      expect(@pd_regime_bag_1.saturday).to eq(true)
      expect(@pd_regime_bag_1.sunday).to eq(true)
    end

    scenario 'when creating a new pd regime bag, some days are deselected' do
      visit new_patient_pd_regime_path(@patient, type: "CAPDRegime")

      select '2015', from: 'pd_regime_start_date_1i'
      select 'May', from: 'pd_regime_start_date_2i'
      select '25', from: 'pd_regime_start_date_3i'

      select 'CAPD 3 exchanges per day', from: 'Treatment'

      find("input.add-bag").click

      select 'Star Brand, Lucky Brand Green–2.34', from: 'Bag Type'

      fill_in 'Volume', with: '230'

      uncheck 'Tuesday'

      uncheck 'Thursday'

      click_on "Save"

      within '.current-regime' do
        expect(page).to have_content("Days: Sun, Mon, Wed, Fri, Sat")
      end
    end

  end
end
