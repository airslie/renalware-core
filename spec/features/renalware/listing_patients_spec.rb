require "rails_helper"

module Renalware
  feature "Listing patients" do
    background do
      create(:patient, surname: "Alpha", forename: "Johnny")
      create(:patient, surname: "Bravo", forename: "Betty")
      create(:patient, surname: "Bravo", forename: "Juliette")
      create(:patient, surname: "Delta", forename: "Dave")
      create(:patient, surname: "Zebra", forename: "Zoe")

      login_as_clinician
    end

    scenario 'Viewing the first page of patients' do
      visit "/patients?per_page=4"
      expect(page).to have_css(".pagination")

      within("#patients") do
        expect(page).to have_content("Alpha, Johnny")
        expect(page).to have_content("Bravo, Betty")
        expect(page).to have_content("Bravo, Juliette")
      end
    end
  end
end
