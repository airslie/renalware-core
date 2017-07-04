When(/^I select death modality$/) do
  within ".patient-content" do
    within "#modality-description-select" do
      select "Death"
    end

    fill_in "Started on", with: "22-09-2014"

    click_on "Save"
  end
end

Then(/^I should see the patient's current modality set as death with start date$/) do
  visit patient_modalities_path(@patient_1)

  expect(page).to have_content("Death")
  expect(page).to have_content(I18n.l(Date.parse("22-09-2014")))
end

Then(/^I should see the date of death and causes of death in the patient's clinical profile$/) do
  visit patient_clinical_profile_path(@patient_1)

  expect(page).to have_content(I18n.l(Date.parse("22-09-2014")))
  expect(page).to have_content("Dementia")
  expect(page).to have_content("Cachexia")
end

Then(/^I should see the patient on the death list$/) do
  visit patient_deaths_path
  within("#patients-deceased") do
    expect(page).to have_content("100 012 4501")
    expect(page).to have_content("M")
  end
end

When(/^I complete the cause of death form$/) do

  within ".edit_patient" do
    fill_in "Date of Death", with: "22-09-2014"

    select "Dementia", from: "Cause of Death (1)"
    select "Cachexia", from: "Cause of Death (2)"

    fill_in "Notes", with: "Heart stopped"

    click_on "Save Cause of Death"
  end
end
