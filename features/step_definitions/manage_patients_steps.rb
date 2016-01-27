Given(/^that I'm logged in$/) do
  @user ||= FactoryGirl.create(:user, :approved, :super_admin)
  login_as @user
end

Given(/^I am on the patients list$/) do
  visit patients_path
end

Given(/^there are ethnicities in the database$/) do
  @ethnicities = ["White", "Black", "Asian"]
  @ethnicities.map! { |e| Renalware::Ethnicity.create!(name: e) }
end

Given(/^some patients who need renal treatment$/) do
  @patient_1 = FactoryGirl.create(:patient,
    nhs_number: "1000124501",
    local_patient_id: "Z999991",
    family_name: "RABBIT",
    given_name: "Roger",
    born_on: "01/01/1947",
    paediatric_patient_indicator: "1",
    sex: "M",
    ethnicity_id: Renalware::Ethnicity.first.id,
    hospital_centre_code: "888"
  )

  @patient_2 = FactoryGirl.create(:patient,
    nhs_number: "1000124502",
    local_patient_id: "Z999992",
    family_name: "DAY",
    given_name: "Doris",
    born_on: "24/06/1970",
    paediatric_patient_indicator: "1",
    sex: "F",
    ethnicity_id: Renalware::Ethnicity.second.id,
    hospital_centre_code: "888"
  )

  @patient_3 = FactoryGirl.create(:patient,
    nhs_number: "1000124503",
    local_patient_id: "Z999993",
    family_name: "CASPER",
    given_name: "Ghost",
    born_on: "28/02/1930",
    paediatric_patient_indicator: "1",
    sex: "M",
    ethnicity_id: Renalware::Ethnicity.third.id,
    hospital_centre_code: "999"
  )
end
