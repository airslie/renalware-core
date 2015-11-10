Given(/^they are on a patient's clinical summary$/) do
  visit patient_clinical_summary_path(@patient_1)
end

Then(/^I should see a patient's modality on their clinical summary$/) do
   expect(page).to have_content("Modal One")
end

Given(/^there are edta causes of death in the database$/) do
  FactoryGirl.create(:edta_code, code: 100, :death_cause => "Death cause one")
  FactoryGirl.create(:edta_code, code: 200, :death_cause => "Death cause two")
end

Then(/^I should see the date of death and causes of death in the patient's demographics$/) do
  visit patient_path(@patient_1)
  expect(page).to have_content("22/09/2014")
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

  within "#patient_died_on_3i" do
    select '22'
  end
  within "#patient_died_on_2i" do
    select 'September'
  end
  within "#patient_died_on_1i" do
    select '2014'
  end

  select "Death cause one", :from => "EDTA Cause of Death (1)"
  select "Death cause two", :from => "EDTA Cause of Death (2)"

  fill_in "Notes/Details", :with => "Heart stopped"

  click_on "Save Cause of Death"
end

