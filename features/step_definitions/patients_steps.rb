Given(/^Patty is a patient$/) do
  @patty = Renalware::Patient.create!(
    nhs_number: "1234567890",
    family_name: "Patty",
    given_name: "ThePatient",
    local_patient_id: "123456",
    sex: "F",
    born_on: Time.zone.today
  )
end

Given(/^Don is a patient$/) do
  @don = Renalware::Patient.create!(
    nhs_number: "1234567891",
    family_name: "Don",
    given_name: "TheDonor",
    local_patient_id: "123457",
    sex: "M",
    born_on: Time.zone.today
  )
end
