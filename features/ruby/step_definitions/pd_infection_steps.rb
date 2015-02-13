Given(/^a patient has PD$/) do
  # pending # express the regexp above with the code you wish you had
end

Given(/^they have been diagnosed with peritonitis$/) do
  visit pd_info_patient_path(@patient)
end

When(/^the Clinician records the episode of peritonitis$/) do
  within "#patient_peritonitis_episode_diagnosis_date_3i" do
    select '25'
  end
  within "#patient_peritonitis_episode_diagnosis_date_2i" do
    select 'December'
  end
  within "#patient_peritonitis_episode_diagnosis_date_1i" do
    select '2014'
  end
  
  within "#patient_peritonitis_episode_start_treatment_date_3i" do
    select '30'
  end
  within "#patient_peritonitis_episode_start_treatment_date_2i" do
    select 'December'
  end
  within "#patient_peritonitis_episode_start_treatment_date_1i" do
    select '2014'
  end
  
  within "#patient_peritonitis_episode_end_treatment_date_3i" do
    select '31'
  end
  within "#patient_peritonitis_episode_end_treatment_date_2i" do
    select 'January'
  end
  within "#patient_peritonitis_episode_end_treatment_date_1i" do
    select '2015'
  end

  fill_in "Episode type", :with => 1
  
  check "Catheter removed"
  check "Line break"
  check "Exit site infection"
  check "Diarrhoea"
  check "Abdominal pain"

  fill_in "Fluid description", :with => 2
  fill_in "White cell total", :with => 1000
  fill_in "Neutro (%)", :with => 20
  fill_in "Lympho (%)", :with => 30
  fill_in "Degen (%)", :with => 25
  fill_in "Other (%)", :with => 25

  fill_in "Organism 1", :with => 1
  fill_in "Organism 2", :with => 2

  fill_in "Notes", :with => "Review in a weeks time"

  fill_in "Antibiotic 1", :with => 11
  fill_in "Antibiotic 2", :with => 12
  fill_in "Antibiotic 3", :with => 13
  fill_in "Antibiotic 4", :with => 14
  fill_in "Antibiotic 5", :with => 15

  fill_in "Route (Antibiotic 1)", :with => 1
  fill_in "Route (Antibiotic 2)", :with => 2
  fill_in "Route (Antibiotic 3)", :with => 3
  fill_in "Route (Antibiotic 4)", :with => 4
  fill_in "Route (Antibiotic 5)", :with => 5
  
  fill_in "Sensitivities", :with => "Antibiotic 1 most effective."

  click_on "Save Peritonitis Episode"

end

Then(/^the episode should be displayed on PD info page$/) do
  visit pd_info_patient_path(@patient)

  expect(page.has_content? "25/12/2014").to be true
  expect(page.has_content? "20/12/2014").to be true
  expect(page.has_content? "31/01/2015").to be true
  expect(page.has_content? "1").to be true
  expect(page.has_content? "1000").to be true
end

