require 'rails_helper'

module Renalware
  feature 'Searching drugs' do
    background do
      %w(Amoxicillin Cephradine Dicloxacillin Metronidazole Penicillin Rifampin Tobramycin Vancomycin).each do |name|
        instance_variable_set(:"@#{name.downcase}", create(:drug, name: name))
      end

      login_as_clinician
      visit drugs_drugs_path
    end

    scenario 'without a query' do
      within('.drugs') do
        expect_to_find_drug('Amoxicillin',   1)
        expect_to_find_drug('Cephradine',    2)
        expect_to_find_drug('Dicloxacillin', 3)
        expect_to_find_drug('Metronidazole', 4)
        expect_to_find_drug('Penicillin',    5)
        expect_to_find_drug('Rifampin',      6)
        expect_to_find_drug('Tobramycin',    7)
        expect_to_find_drug('Vancomycin',    8)
      end
    end

    scenario 'with a search term' do
      fill_in 'q_name_or_drug_types_name_start', with: 'Amox'

      click_on 'Search'

      within('.drugs') do
        expect_to_find_drug('Amoxicillin',   1)
      end
    end

    scenario 'with paged results' do
      Kaminari.configure { |k| k.default_per_page = 5 }

      visit drugs_drugs_path

      within('.drugs') do
        expect_to_find_drug('Amoxicillin',   1)
        expect_to_find_drug('Cephradine',    2)
        expect_to_find_drug('Dicloxacillin', 3)
        expect_to_find_drug('Metronidazole', 4)
        expect_to_find_drug('Penicillin',    5)
      end

      within('.pagination') do
        click_on 'Next'
      end

      within('.drugs') do
        expect_to_find_drug('Rifampin',      1)
        expect_to_find_drug('Tobramycin',    2)
        expect_to_find_drug('Vancomycin',    3)
      end
    end
  end
end

def expect_to_find_drug(name, row=1)
  expect(page).to have_css("tr:nth-child(#{row})", text: name)
end
