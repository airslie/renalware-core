Given(/^I am on the add a new patient page$/) do
  visit new_patient_path
end

Given(/^I've searched for a patient in the database$/) do
  #click_on "Search Renalware Patients"
end

When(/^I complete the add a new patient form$/) do
  fill_in "NHS Number", :with => "1000124503"
  fill_in "Surname", :with => "Smith"
  fill_in "Forename", :with => "Ian"
  within "#patient_dob_1i" do
    select '1960' 
  end
  within "#patient_dob_2i" do
    select 'January'
  end
  within "#patient_dob_3i" do
    select '1'
  end
  click_on "Add a New Renal Patient"
end

Then(/^I should see the new patient in the Renal Patient List$/) do
  visit new_patient_path #need to change to index path
end