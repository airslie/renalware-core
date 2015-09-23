Given(/^I am on the patients list$/) do
  visit patients_path
end

Given(/^there are ethnicities in the database$/) do
  @ethnicities = ["White", "Black", "Asian"]
  @ethnicities.map! { |e| Renalware::Ethnicity.create!(:name => e) }
end

Given(/^some patients who need renal treatment$/) do
  @patient_1 = FactoryGirl.create(:patient,
    :nhs_number => "1000124501",
    :local_patient_id => "Z999991",
    :surname => "RABBIT",
    :forename => "Roger",
    :birth_date => "01/01/1947",
    :paediatric_patient_indicator => "1",
    :sex => 1,
    :ethnicity_id => Renalware::Ethnicity.first.id,
    :hosp_centre_code => "888"
  )

  @patient_2 = FactoryGirl.create(:patient,
    :nhs_number => "1000124502",
    :local_patient_id => "Z999992",
    :surname => "DAY",
    :forename => "Doris",
    :birth_date => "24/06/1970",
    :paediatric_patient_indicator => "1",
    :sex => 2,
    :ethnicity_id => Renalware::Ethnicity.second.id,
    :hosp_centre_code => "888"
  )

  @patient_3 = FactoryGirl.create(:patient,
    :nhs_number => "1000124503",
    :local_patient_id => "Z999993",
    :surname => "CASPER",
    :forename => "Ghost",
    :birth_date => "28/02/1930",
    :paediatric_patient_indicator => "1",
    :sex => 1,
    :ethnicity_id => Renalware::Ethnicity.third.id,
    :hosp_centre_code => "999"
  )
end

Given(/^I am on the add a new patient page$/) do
  visit new_patient_path
end

Given(/^I've selected the patient from the search results$/) do
  click_on "Demographics"
end

When(/^I complete the add a new patient form$/) do
  fill_in "NHS Number", :with => "1000124504"
  fill_in "Local Patient ID", :with => "Z999994"
  fill_in "Surname", :with => "Smith"
  fill_in "Forename", :with => "Ian"

  select "Male", from: "Sex"

  select "White", from: "Ethnicity"

  within "#patient_birth_date_1i" do
    select '1960'
  end
  within "#patient_birth_date_2i" do
    select 'January'
  end
  within "#patient_birth_date_3i" do
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

  click_on "Save"
end

When(/^I update the patient's demographics$/) do
  click_on "Edit"
  fill_in "Forename", :with => "Roger"
end

When(/^submit the update form$/) do
  click_on "Update"
end

Then(/^I should see the new patient in the Renal Patient List$/) do
  expect(page).to have_content("1000124504")
  expect(page).to have_content("Z999994")
  expect(page).to have_content("Smith")
  expect(page).to have_content("Ian")
  expect(page).to have_content("1")
  expect(page).to have_content("White")
  expect(page).to have_content("01/01/1960")
  expect(page).to have_content("false")
  expect(page).to have_content(@address_diagnosis_street_1)
  expect(page).to have_content(@current_street_1)
end

Then(/^the patient should be created$/) do
  expect(Renalware::Patient.count).to eq(1)
  expect(Renalware::Address.count).to eq(2)
  @patient = Renalware::Patient.first
  expect(@patient.current_address_id).to_not be_nil
  expect(@patient.address_at_diagnosis_id).to_not be_nil
end

Then(/^I should see the patient's demographics on their profile page$/) do
  expect(page).to have_content("1000124501")
  expect(page).to have_content("RABBIT")
  expect(page).to have_content("R")
end

Then(/^I should see the patient's new demographics on their profile page$/) do
  expect(page).to have_content("R")
end
