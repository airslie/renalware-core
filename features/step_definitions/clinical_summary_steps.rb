Given(/^they are on a patient's clinical summary$/) do
  visit patient_clinical_summary_path(@patient_1)
end

Then(/^I should see a patient's modality on their clinical summary$/) do
   expect(page).to have_content("Modal One")
end
