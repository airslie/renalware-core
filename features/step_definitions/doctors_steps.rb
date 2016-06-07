regex = /^([A-Za-z]+) ([A-Za-z]+) is a doctor with telephone number: (\d+)$/
Given(regex) do |given_name, family_name, telephone|
  Renalware::Doctor.create!(
    email: "john.merrill@nhs.net",
    given_name: given_name,
    family_name: family_name,
    practitioner_type: 'GP',
    telephone: telephone,
    address: Renalware::Address.new(street_1: "123 Fake street"),
    code: SecureRandom.uuid
  )
end
