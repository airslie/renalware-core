Given(/^Patty is a patient in the system$/) do
  @patty = Renalware::Patient.create!(
    nhs_number: "1234567890",
    surname: "Patty",
    forename: "ThePatient",
    local_patient_id: "123456",
    sex: "F",
    birth_date: Time.zone.today
  )
end

Given(/^Don is a donor in the system$/) do
  @don = Renalware::Patient.create!(
    nhs_number: "1234567890",
    surname: "Don",
    forename: "TheDonor",
    local_patient_id: "123456",
    sex: "F",
    birth_date: Time.zone.today
  )
end
