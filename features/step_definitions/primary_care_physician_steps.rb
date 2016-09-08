Given(/^([A-Za-z]+) ([A-Za-z]+) is a primary care physician with telephone number: (\d+)$/) do |given_name, family_name, telephone|
  Renalware::Patients::PrimaryCarePhysician.create!(
    email: "john.merrill@nhs.net",
    given_name: given_name,
    family_name: family_name,
    practitioner_type: "GP",
    telephone: telephone,
    address: Renalware::Address.new(street_1: "123 Fake street"),
    code: SecureRandom.uuid
  )
end
