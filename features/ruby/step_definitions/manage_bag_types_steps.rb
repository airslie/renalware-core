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
  fill_in "Volume of icodextrin soln (ml)", with: 20

  check "Low glucose degradation product (GDP)"
  check "Low sodium solution"

  click_on "Save"
end

Then(/^I should see the new bag type on the bag type list$/) do
  pending # express the regexp above with the code you wish you had
end