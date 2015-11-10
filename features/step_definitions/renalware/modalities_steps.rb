Given(/^there are modality reasons in the database$/) do
  @modality_reasons = [
    [nil, nil, "Other"],
    ["Modalities::PDToHaemodialysis", 111, "Reason One"],
    ["Modalities::HaemodialysisToPD", 222, "Reason Two"]
  ]
  @modality_reasons.map! do |mr|
    type = mr[0] ? "Renalware::#{mr[0]}" : nil
    @modality_reason = Renalware::Modalities::Reason.create!(
      type: type, rr_code: mr[1], description: mr[2]
    )
  end
end

Given(/^I choose to add a modality$/) do
  visit new_patient_modality_path(@patient_1)
end

When(/^I complete the modality form$/) do

  within "#modality-description-select" do
    select "Modal One"
  end

  select "PD To Haemodialysis", from: "Type of Change"
  select "Reason One", from: "Reason for Change"

  select "2014", from: "modality_started_on_1i"
  select "December", from: "modality_started_on_2i"
  select "1", from: "modality_started_on_3i"

  fill_in "Notes", with: "Needs wheel chair access"

  click_on "Save"
end

Then(/^I should see a patient's modality on their clinical summary$/) do
   expect(page).to have_content("Modal One")
end


Given(/^there are modality codes in the database$/) do
  @modal_descriptions = [
    ["Modal One", "modelone"],
    ["Modal Two", "modeltwo"],
    ["PD Modality", "pdmodality"],
    ["Death", "death"]
  ]
  @modal_descriptions.map! {|d| FactoryGirl.create(:modality_description, name: d[0], code: d[1])}

  @modal_one = @modal_descriptions[0]
  @modal_two = @modal_descriptions[1]
  @modal_pd = @modal_descriptions[2]
  @modal_death = @modal_descriptions[3]
end

Given(/^that I'm on the add a new modal page$/) do
  visit new_modalities_description_path
end

Given(/^that I choose to edit a modality$/) do
  visit edit_modalities_description_path(@modal_two)
end

When(/^I complete the form for a new modal$/) do
  fill_in "Modal Name", with: "New Modal"
  fill_in "Modal Code", with: "newmodels"
  click_on "Save"
end

When(/^I complete the form for editing a modality$/) do
  fill_in "Modal Name", with: "This is an edited modal"
  click_on "Update"
end

Then(/^I should see the new modal on the modalities list$/) do
  expect(page).to have_content("New Modal")
  expect(page).to have_content("newmodel")
end

Then(/^I should see the updated modal on the modality list$/) do
  expect(page).to have_content("This is an edited modal")
end

Given(/^I am on the modalities index$/) do
  visit modalities_descriptions_path
end

When(/^I choose to soft delete a modal$/) do

  within("table.modality-codes tbody tr:first-child") do
    click_link("Delete")
  end
end

Then(/^I should see the modal removed from the modalities list$/) do
  expect(page).to have_no_content("Modal One")
end
