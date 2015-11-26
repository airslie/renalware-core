Given(/^there are edta causes of death in the database$/) do
  FactoryGirl.create(:edta_code, code: 100, death_cause: "Death cause one")
  FactoryGirl.create(:edta_code, code: 200, death_cause: "Death cause two")
end

When(/^I select death modality$/) do
  within "#modality-description-select" do
    select "Death"
  end

  fill_in "Started on", with: "01-04-2015"

  click_on "Save"
end

Then(/^I should see the patient's current modality set as death with start date$/) do
  visit patient_modalities_path(@patient_1)

  expect(page).to have_content("Death")
  expect(page).to have_content("01-04-2015")
end

Then(/^I should see the date of death and causes of death in the patient's demographics$/) do
  visit patient_path(@patient_1)

  expect(page).to have_content("22-09-2014")
  expect(page).to have_content("Death cause one")
  expect(page).to have_content("Death cause two")
end

Then(/^I should see the patient on the death list$/) do
  visit patient_deaths_path
  within("#patients-deceased") do
    expect(page).to have_content("1000124501")
    expect(page).to have_content("Male")
  end
end

When(/^I complete the cause of death form$/) do

  fill_in "Date of Death", with: "22-09-2014"

  select "Death cause one", from: "EDTA Cause of Death (1)"
  select "Death cause two", from: "EDTA Cause of Death (2)"

  fill_in "Notes", with: "Heart stopped"

  click_on "Save Cause of Death"
end

