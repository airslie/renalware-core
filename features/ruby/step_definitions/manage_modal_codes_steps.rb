Given(/^that I'm on the add a new modal page$/) do
  visit new_modality_code_path
end

When(/^I complete the form for a new modal$/) do
  fill_in "Modal Name",:with => "New Modal" 
  fill_in "Modal Code",:with => "newmodels"
  click_on "Save" 
end

Then(/^I should see the new modal on the modalities list$/) do
  save_and_open_page
  expect(page.has_content? "New Modal").to be true
  expect(page.has_content? "newmodel").to be true
end