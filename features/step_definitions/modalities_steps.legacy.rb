Given /^I choose to add a modality$/ do
  visit new_patient_modality_path(@patty || @patient_1)
end
