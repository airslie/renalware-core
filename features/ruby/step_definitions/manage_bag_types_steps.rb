Given(/^that I'm on the add a new bag type page$/) do
  visit new_bag_type_path
end

When(/^I complete the form for a bag type$/) do
  select 'Baxter', from: 'Manufacturer'

  fill_in "Description", with: "Yellow–2.34"

  fill_in "Glucose content (g/l)", with: 31.7

  check "Contains amino acid soln?"
  check "Contains icodextrin soln?"

  check "Low glucose degradation product (GDP)"
  uncheck "Low sodium solution"

  fill_in 'Sodium content (mmole/l)', with: 8
  fill_in 'Lactate content (mmole/l)', with: 7
  fill_in 'Bicarbonate content (mmole/l)', with: 9
  fill_in 'Calcium content (mmole/l)', with: 2.56
  fill_in 'Magnesium content (mmole/l)', with: 3.47

  click_on "Save New Bag Type"
end

Then(/^I should see the new bag type on the bag type list$/) do
  expect(page).to have_content("Baxter")
  expect(page).to have_content("Yellow–2.34")
  expect(page).to have_content("31.7")

  within('table.bag-types-list tbody tr:first-child td:nth-child(4)') do
    expect(page).to have_content("Yes")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(5)') do
    expect(page).to have_content("Yes")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(6)') do
    expect(page).to have_content("Yes")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(7)') do
    expect(page).to have_content("No")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(8)') do
    expect(page).to have_content("8")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(9)') do
    expect(page).to have_content("7")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(10)') do
    expect(page).to have_content("9")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(11)') do
    expect(page).to have_content("2.56")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(12)') do
    expect(page).to have_content("3.47")
  end
end

Given(/^there are PD bag types in the database$/) do
  @bag_type_13_6 = FactoryGirl.create(:bag_type,
    manufacturer: "Sunshine Brand",
    description: "Blue–1.36",
    glucose_grams_per_litre: 13.6,
    amino_acid: false,
    icodextrin: true,
    low_glucose_degradation: false,
    low_sodium: true,
    sodium_mmole_l: 2,
    lactate_mmole_l: 3,
    bicarbonate_mmole_l: 59,
    calcium_mmole_l: 3.21,
    magnesium_mmole_l: 6.55
  )

  @bag_type_22_7 = FactoryGirl.create(:bag_type,
    manufacturer: "Rainbow Brand",
    description: "Red–2.27",
    glucose_grams_per_litre: 22.7,
    amino_acid: true,
    icodextrin: true,
    low_glucose_degradation: false,
    low_sodium: true,
    sodium_mmole_l: 7,
    lactate_mmole_l: 5,
    bicarbonate_mmole_l: 38,
    calcium_mmole_l: 4.22,
    magnesium_mmole_l: 2.35
  )

  @bag_type_38_6 = FactoryGirl.create(:bag_type,
    manufacturer: "Unicorn Brand",
    description: "Green–3.86",
    glucose_grams_per_litre: 38.6,
    amino_acid: true,
    icodextrin: false,
    low_glucose_degradation: false,
    low_sodium: true,
    sodium_mmole_l: 3,
    lactate_mmole_l: 7,
    bicarbonate_mmole_l: 26,
    calcium_mmole_l: 8.28,
    magnesium_mmole_l: 1.45
  )

  @bag_type_other = FactoryGirl.create(:bag_type,
    manufacturer: "Lucky Brand",
    description: "Orange–5.35",
    glucose_grams_per_litre: 26.8,
    amino_acid: true,
    icodextrin: true,
    low_glucose_degradation: false,
    low_sodium: false,
    sodium_mmole_l: 9,
    lactate_mmole_l: 10,
    bicarbonate_mmole_l: 18,
    calcium_mmole_l: 6.27,
    magnesium_mmole_l: 3.46
  )
end

Given(/^that I choose to edit a bag type$/) do
  visit edit_bag_type_path(@bag_type_38_6)
end

When(/^I complete the form for editing a bag type$/) do
  uncheck "Low glucose degradation product (GDP)"

  click_on "Update This Bag Type"
end

Then(/^I should see the updated bag type on the bag types list$/) do
  within('table.bag-types-list tbody tr:first-child td:nth-child(6)') do
    have_css("td", text: "No", count: 1)
  end
end

When(/^I choose to soft delete a bag type$/) do
  visit bag_types_path
  find("#delete-bag-type-#{@bag_type_22_7.id}").click
end

Then(/^I should no longer see the soft deleted bag type on the bag types list$/) do
  expect(page).to have_content("Blue–1.36")
  expect(page).not_to have_content("Red–2.27")
end