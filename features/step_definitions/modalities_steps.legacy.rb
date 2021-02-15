# frozen_string_literal: true

Given(/^I choose to add a modality$/) do
  visit new_patient_modality_path(@patty || @patient_1)
end

When(/^I complete the modality form$/) do
  within "#modality-description-select" do
    select "Other"
  end

  select "PD To Haemodialysis", from: "Type of Change"
  select "Other reasons", from: "Reason for Change"
  fill_in "Started on", with: "01-12-2014"

  fill_in "Notes", with: "Needs wheel chair access"

  click_on t("btn.save")
end

Then(/^I should see a patient's modality on their clinical summary$/) do
  expect(page).to have_content("Other")
end
