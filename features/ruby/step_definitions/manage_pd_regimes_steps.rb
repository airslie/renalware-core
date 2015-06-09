Given(/^I choose to record a new pd regime$/) do
  click_on "Add PD Regime"
end

When(/^I complete the form for a pd regime$/) do

  select '2015', from: 'pd_regime_start_date_1i'
  select 'April', from: 'pd_regime_start_date_2i'
  select '2', from: 'pd_regime_start_date_3i'

  select '2015', from: 'pd_regime_end_date_1i'
  select 'June', from: 'pd_regime_end_date_2i'
  select '1', from: 'pd_regime_end_date_3i'

  fill_in "Daily volume of 1.36% glucose/litre (ml)", with: 15
  fill_in "Daily volume of 2.27% glucose/litre (ml)", with: 25
  fill_in "Daily volume of 3.86% glucose/litre (ml)", with: 35
  fill_in "Daily volume of amino acid soln (ml)", with: 45
  fill_in "Daily volume of icodextrin soln (ml)", with: 60

  uncheck "Low glucose degradation product (GDP)"
  check "Low sodium solution"
  check "On additional HD"

  click_on "Save PD Regime"
end

Then(/^I should see the new pd regime on the PD info page\.$/) do
  expect(page).to have_content("02/04/2015")
  expect(page).to have_content("01/06/2015")
  expect(page).to have_content("15")
  expect(page).to have_content("25")
  expect(page).to have_content("35")
  expect(page).to have_content("45")
  expect(page).to have_content("60")
  expect(page).to have_content("No")
  expect(page).to have_css("td", text: "Yes", count: 2)
end
