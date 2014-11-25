Given(/^that I'm logged in$/) do
end

Given(/^there are ethnicities in the database$/) do
  @ethnicities = ["White", "Black", "Asian"]
  @ethnicities.map! { |e| Ethnicity.create!(:name => e) }
end

Given(/^I am on the add a new patient page$/) do
  visit new_patient_path
end

Given(/^I have a patient in the database$/) do
  @patient = Patient.find_or_create_by!(
    :nhs_number => "1000124502",
    :local_patient_id => "Z999999",
    :surname => "RABBIT",
    :forename => "R",
    :dob => "01/01/1947",
    :paediatric_patient_indicator => "1",
    :sex => 1,
    :ethnicity_id => Ethnicity.last.id
    )
end

Given(/^I've searched for a patient in the database$/) do
  #click_on "Search Renalware Patients"
end

Given(/^I've selected the patient from the search results$/) do
  visit demographics_patient_path(@patient)
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

  uncheck "If under 18 years, is the recipient being treated in a paediatric unit?"

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

When(/^I update the patient's demographics$/) do
  click_on "Edit Demographics"
  fill_in "Forename", :with => "Roger"
  click_on "Update Demographics"
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

Then(/^I should see the patient's demographics on their profile page$/) do
  expect(page.has_content? "1000124502").to be true
  expect(page.has_content? "RABBIT").to be true
  expect(page.has_content? "R").to be true
end

Then(/^I should see the patient's new demographics on their profile page$/) do
  expect(page.has_content? "Roger").to be true
end