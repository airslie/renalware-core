Given(/^that I'm on the add a new bag type page$/) do
  visit new_bag_type_path
end

When(/^I complete the form for a bag type$/) do
  fill_in "Manufacturer", with: "Brand One"
  fill_in "Description", with: "Yellow–2.34"

  fill_in "Glucose content (g/l)", with: 31.7

  check "Contains amino acid soln?"
  check "Contains icodextrin soln?"

  check "Low glucose degradation product (GDP)"
  uncheck "Low sodium solution"

  fill_in 'Sodium content', with: 8
  fill_in 'Lactate content', with: 7
  fill_in 'Calcium content', with: 2.56
  fill_in 'Magnesium content', with: 3.47

  click_on "Save New Bag Type"
end

Then(/^I should see the new bag type on the bag type list$/) do
  expect(page).to have_content("Brand One")
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
    expect(page).to have_content("2.56")
  end
  within('table.bag-types-list tbody tr:first-child td:nth-child(11)') do
    expect(page).to have_content("3.47")
  end
end

Given(/^there are PD bag types in the database$/) do
  @bag_type_1 = FactoryGirl.create(:bag_type,
    manufacturer: "Sunshine Brand",
    description: "Blue–2.34",
    glucose_grams_per_litre: 21.5,
    amino_acid: false,
    icodextrin: true,
    low_glucose_degradation: false,
    low_sodium: true,
    sodium_content: 2,
    lactate_content: 3,
    calcium_content: 3.21,
    magnesium_content: 6.55
  )

  @bag_type_2 = FactoryGirl.create(:bag_type,
    manufacturer: "Rainbow Brand",
    description: "Red–3.25",
    glucose_grams_per_litre: 17.7,
    amino_acid: true,
    icodextrin: true,
    low_glucose_degradation: false,
    low_sodium: true,
    sodium_content: 7,
    lactate_content: 5,
    calcium_content: 4.22,
    magnesium_content: 2.35
  )

  @bag_type_3 = FactoryGirl.create(:bag_type,
    manufacturer: "Unicorn Brand",
    description: "Green–5.35",
    glucose_grams_per_litre: 32.3,
    amino_acid: true,
    icodextrin: false,
    low_glucose_degradation: false,
    low_sodium: true,
    sodium_content: 3,
    lactate_content: 7,
    calcium_content: 8.28,
    magnesium_content: 1.45
  )

  @bag_type_4 = FactoryGirl.create(:bag_type,
    manufacturer: "Lucky Brand",
    description: "Orange–5.35",
    glucose_grams_per_litre: 26.8,
    amino_acid: true,
    icodextrin: true,
    low_glucose_degradation: false,
    low_sodium: false,
    sodium_content: 9,
    lactate_content: 10,
    calcium_content: 6.27,
    magnesium_content: 3.46
  )
end

Given(/^that I choose to edit a bag type$/) do
  visit edit_bag_type_path(@bag_type_3)
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
  find("#delete-bag-type-#{@bag_type_2.id}").click
end

Then(/^I should no longer see the soft deleted bag type on the bag types list$/) do
  expect(page).to have_content("Blue–2.34")
  expect(page).not_to have_content("Red–3.25")
end