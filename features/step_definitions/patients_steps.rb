Given(/^Patty is a patient$/) do
  @patty = Renalware::Patient.create!(
    nhs_number: "1234567890",
    family_name: "Patty",
    given_name: "ThePatient",
    local_patient_id: "123456",
    sex: "F",
    born_on: Time.zone.today,
    doctor: doctor,
    current_address_attributes: {
      name: "Patty ThePatient",
      street_1: "1 Main St",
      city: "London"
    },
    by: Renalware::User.find_system_user
  )
end

Given(/^Don is a patient$/) do
  @don = Renalware::Patient.create!(
    nhs_number: "1234567891",
    family_name: "Don",
    given_name: "TheDonor",
    local_patient_id: "123457",
    sex: "M",
    born_on: Time.zone.today,
    doctor: doctor,
    by: Renalware::User.find_system_user
  )
  @don.create_current_address(
    street_1: "2 Main St",
    city: "London"
  )
end

Given(/^Doug is Patty's doctor$/) do
  @doug = @patty.doctor
end

Then(/^the patient is created with the following attributes:$/) do |table|
  expect_patient_to_be_created(table.rows_hash)
end
