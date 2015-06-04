Given(/^that I'm on the add a new bag type page$/) do
  visit new_bag_type_path
end

When(/^I complete the form for a bag type$/) do
  fill_in "Manufacturer", with: "Brand One, Brand Two"
  fill_in "Description", with: "Yellow–2.34"
  fill_in "Volume of 1.36% glucose/litre (ml)", with: 10
  fill_in "Volume of 2.27% glucose/litre (ml)", with: 20
  fill_in "Volume of 3.86% glucose/litre (ml)", with: 30
  fill_in "Volume of amino acid soln (ml)", with: 40
  fill_in "Volume of icodextrin soln (ml)", with: 55

  check "Low glucose degradation product (GDP)"
  uncheck "Low sodium solution"

  click_on "Save"
end

Then(/^I should see the new bag type on the bag type list$/) do
  expect(page).to have_content("Brand One, Brand Two")
  expect(page).to have_content("Yellow–2.34")
  expect(page).to have_content("10")
  expect(page).to have_content("20")
  expect(page).to have_content("30")
  expect(page).to have_content("40")
  expect(page).to have_content("55")
  expect(page).to have_content("Yes")
  expect(page).to have_content("No")
end

Given(/^that I have saved bag types$/) do
  @bag_type_1 = FactoryGirl.create(:bag_type,
    manufacturer: "Sunshine Brand, Unicorn Brand",
    description: "Blue–2.34",
    glucose_ml_percent_1_36: 15,
    glucose_ml_percent_2_27: 25,
    glucose_ml_percent_3_86: 35,
    amino_acid_ml: 45,
    icodextrin_ml: 55,
    low_glucose_degradation: 1,
    low_sodium: 1
  )

  @bag_type_2 = FactoryGirl.create(:bag_type,
    manufacturer: "Rainbow Brand, Best Brand",
    description: "Red–3.25",
    glucose_ml_percent_1_36: 28,
    glucose_ml_percent_2_27: 28,
    glucose_ml_percent_3_86: 38,
    amino_acid_ml: 48,
    icodextrin_ml: 58,
    low_glucose_degradation: 0,
    low_sodium: 1
  )
end

Given(/^that I choose to edit a bag type$/) do
  visit edit_bag_type_path(@bag_type_1)
end

When(/^I complete the form for editing a bag type$/) do
  fill_in "Volume of 2.27% glucose/litre (ml)", with: 62
  fill_in "Volume of amino acid soln (ml)", with: 37
  uncheck "Low glucose degradation product (GDP)"

  click_on "Update Bag Type"
end

Then(/^I should see the updated bag type on the bag types list$/) do
  expect(page).to have_content("62")
  expect(page).to have_content("37")
  expect(page).to have_css("td", text: "No", count: 2)
end

When(/^I choose to soft delete a bag type$/) do
  visit bag_types_path
  find("#delete-bag-type-#{@bag_type_2.id}").click
end

Then(/^I should no longer see the soft deleted bag type on the bag types list$/) do
  expect(page).to have_content("Blue–2.34")
  expect(page).not_to have_content("Red–3.25")
end