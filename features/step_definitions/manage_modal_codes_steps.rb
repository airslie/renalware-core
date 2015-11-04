Given(/^there are modality codes in the database$/) do
  @modal_codes = [["Modal One", "modelone"], ["Modal Two", "modeltwo"], ["PD Modality", "pdmodality"], ["Death", "death"]]
  @modal_codes.map! {|d| FactoryGirl.create(:modality_code, :name => d[0], :code => d[1])}

  @modal_one = @modal_codes[0]
  @modal_two = @modal_codes[1]
  @modal_pd = @modal_codes[2]
  @modal_death = @modal_codes[3]
end

Given(/^that I'm on the add a new modal page$/) do
  visit new_modalities_code_path
end

Given(/^that I choose to edit a modality$/) do
  visit edit_modalities_code_path(@modal_two)
end

When(/^I complete the form for a new modal$/) do
  fill_in "Modal Name",:with => "New Modal"
  fill_in "Modal Code",:with => "newmodels"
  fill_in "Modal Site",:with => "New Modal Site"
  click_on "Save"
end

When(/^I complete the form for editing a modality$/) do
  fill_in "Modal Name",:with => "This is an edited modal"
  click_on "Update"
end

Then(/^I should see the new modal on the modalities list$/) do
  expect(page).to have_content("New Modal")
  expect(page).to have_content("newmodel")
  expect(page).to have_content("Modal Site")
end

Then(/^I should see the updated modal on the modality list$/) do
  expect(page).to have_content("This is an edited modal")
end

Given(/^I am on the modalities index$/) do
  visit modalities_codes_path
end

When(/^I choose to soft delete a modal$/) do

  within("table.modality-codes tbody tr:first-child") do
    click_link('Delete')
  end

end

Then(/^I should see the modal removed from the modalities list$/) do
  expect(page).to have_no_content("Modal One")
end
