Given(/^that I'm on the add a new bag type page$/) do
  visit new_bag_type_path
end

When(/^I complete the form for a bag type$/) do
  fill_in "Manufacturer", with: "Brand One, Brand Two"
  fill_in "Bag description", with: "Yellow–2.34"
  fill_in "Volume of 1.36% glucose/liter (ml)", with: 10
  fill_in "Volume of 2.27% glucose/liter (ml)", with: 20
  fill_in "Volume of 3.86% glucose/liter (ml)", with: 30
  fill_in "Volume of amino acid soln/liter (ml)", with: 40
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