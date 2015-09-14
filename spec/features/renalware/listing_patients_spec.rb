require 'rails_helper'

module Renalware
  feature 'Listing patients' do
    background do
      create(:patient, surname: 'Alpha', forename: 'Johnny')
      create(:patient, surname: 'Bravo', forename: 'Betty')
      create(:patient, surname: 'Bravo', forename: 'Juliette')
      create(:patient, surname: 'Delta', forename: 'Dave')
      create(:patient, surname: 'Zebra', forename: 'Zoe')

      login_as_clinician
    end

    scenario 'Viewing the first page of patients' do
      visit '/patients?per_page=4'
      expect(page).to have_css('nav.pagination', text: '1 2 Next › Last »')

      within('table.patients tbody') do
        expect(page).to have_css('tr:first-child td[data-heading=Name]', text: 'Alpha, Johnny')
        expect(page).to have_css('tr:nth-child(2) td[data-heading=Name]', text: 'Bravo, Betty')
        expect(page).to have_css('tr:nth-child(3) td[data-heading=Name]', text: 'Bravo, Juliette')
      end
    end

    scenario 'Paging to the second page of patients' do
      visit '/patients?per_page=4'
      click_link 'Next ›'
      expect(page).to have_css('nav.pagination', text: '« First ‹ Prev 1 2')
    end
  end
end