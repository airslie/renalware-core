Given(/^I am on the add a new patient page$/) do
  visit new_patient_path
end

Given(/^I've searched for a patient in the database$/) do
  #click_on "Search Renalware Patients"
end

When(/^I complete the add a new patient form$/) do
  fill_in "NHS Number", :with => "1000124503"
  fill_in "Local Patient ID", :with => "Z999999"
  fill_in "Surname", :with => "Smith"
  fill_in "Forename", :with => "Ian"

  select "Male", from: "Sex"

  select "White", from: "Ethnicity"
  
  within "#patient_dob_1i" do
    select '1960'
  end
  within "#patient_dob_2i" do
    select 'January'
  end
  within "#patient_dob_3i" do
    select '1'
  end
  uncheck "Paediatric patient indicator"

  within "#current_address" do
    @current_street_1 = Faker::Address.street_address
    fill_in "Street 1", :with => @current_street_1
    fill_in "Street 2", :with => Faker::Address.secondary_address
    fill_in "City", :with => Faker::Address.city
    fill_in "County", :with => Faker::AddressUK.county
    fill_in "Postcode", :with => Faker::AddressUK.postcode
  end

  within "#address_at_diagnosis" do
    @address_diagnosis_street_1 = Faker::Address.street_address
    fill_in "Street 1", :with => @address_diagnosis_street_1
    fill_in "Street 2", :with => Faker::Address.secondary_address
    fill_in "City", :with => Faker::Address.city
    fill_in "County", :with => Faker::AddressUK.county
    fill_in "Postcode", :with => Faker::AddressUK.postcode
  end

  click_on "Save a New Renal Patient"
end

Then(/^I should see the new patient in the Renal Patient List$/) do
  expect(page.has_content? "1000124503").to be true
  expect(page.has_content? "Z999999").to be true
  expect(page.has_content? "Smith").to be true
  expect(page.has_content? "Ian").to be true
  expect(page.has_content? "1").to be true
  expect(page.has_content? "White").to be true
  expect(page.has_content? "1960-01-01").to be true
  expect(page.has_content? "false").to be true
  expect(page.has_content? @address_diagnosis_street_1).to be true
  expect(page.has_content? @current_street_1).to be true
end

Then(/^the patient should be created$/) do
  expect(Patient.count).to eq(1)
  expect(Address.count).to eq(2)
  @patient = Patient.first
  expect(@patient.current_address_id).to_not be_nil
  expect(@patient.address_at_diagnosis_id).to_not be_nil
end
