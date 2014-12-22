Given(/^there are modalities in the database$/) do
  @modal_codes = [["Modal One", "modelone"], ["Modal Two", "modeltwo"], ["Modal Three", "Modalthree"]]
  @modal_codes.map! {|d| @modal_code = ModalityCode.create!(:name => d[0], :code => d[1])}
end

Given(/^that I'm on the add a new modal page$/) do
  visit new_modality_code_path
end

When(/^I complete the form for a new modal$/) do
  fill_in "Modal Name",:with => "New Modal" 
  fill_in "Modal Code",:with => "newmodels"
  click_on "Save" 
end

Then(/^I should see the new modal on the modalities list$/) do
  expect(page.has_content? "New Modal").to be true
  expect(page.has_content? "newmodel").to be true
end

Given(/^that I choose to edit a modality$/) do
  visit edit_modality_code_path(@modal_code)
end

When(/^I complete the form for editing a modality$/) do
  fill_in "Modal Name",:with => "This is an edited modal"
  click_on "Update Modal" 
end

Then(/^I should see the updated drug on the modality list$/) do
  expect(page.has_content? "This is an edited modal").to be true
end