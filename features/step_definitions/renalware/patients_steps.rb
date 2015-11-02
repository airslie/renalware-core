Given(/^Patty is a patient in the system$/) do
  @patty = Renalware::Patient.create!(
    nhs_number: "1234567890",
    family_name: "Patty",
    given_name: "ThePatient",
    local_patient_id: "123456",
    sex: "F",
    born_on: Time.zone.today
  )
end

Given(/^Don is a donor in the system$/) do
  @don = Renalware::Patient.create!(
    nhs_number: "1234567890",
    family_name: "Don",
    given_name: "TheDonor",
    local_patient_id: "123456",
    sex: "F",
    born_on: Time.zone.today
  )
end
