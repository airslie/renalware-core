Given(/^I have a patient in the database$/) do
  @patient = Patient.create!(
    :nhs_number => "1000124502", 
    :local_patient_identifier => "Z999999", 
    :surname => "RABBIT", 
    :forename => "R",
    :date_of_birth => "01/01/1947",
    :paediatric_patient_flag => 1,
    :sex => 1,
    :ethnic_category => "A"
    ) 
end

Given(/^that I'm logged in$/) do
end

Given(/^I've searched for a patient$/) do
end

Given(/^I've selected the patient from the search results$/) do
  visit "patients/#{@patient.id}"
end

Then(/^I should see the patient's demographics on their profile page$/) do
  expect(page.has_content? "PATIENT DEMOGRAPHICS").to be true
  expect(page.has_content? "1000124502").to be true
  expect(page.has_content? "Mr").to be true
  expect(page.has_content? "RABBIT").to be true
  expect(page.has_content? "R").to be true
  expect(page.has_content? "M").to be true
  expect(page.has_content? "01/01/1947").to be true
end