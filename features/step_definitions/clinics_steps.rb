Given /^Clinics$/ do |clinics|
  clinics.hashes.each do |clinic_params|
    create_clinic(clinic_params)
  end
end

Given /the following consultants:/ do |table|
  table.raw.flatten.each do |name|
    FactoryBot.create(:consultant, name: name, code: SecureRandom.uuid)
  end
end

Given /Patty has a recorded clinic visit/ do
  @clinic_visit = create_clinic_visit(@patty, @clyde || Renalware::User.first)
end
