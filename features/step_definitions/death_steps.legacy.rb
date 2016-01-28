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
  expect(page).to have_content("Dementia")
  expect(page).to have_content("Cachexia")
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

  select "Dementia", from: "EDTA Cause of Death (1)"
  select "Cachexia", from: "EDTA Cause of Death (2)"

  fill_in "Notes", with: "Heart stopped"

  click_on "Save Cause of Death"
end

