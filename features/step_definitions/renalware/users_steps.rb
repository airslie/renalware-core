Given(/^Clyde is a clinician$/) do
  @clyde = Renalware::User.create!(
    first_name: "Clyde",
    last_name: "The Clinician",
    username: "clyde",
    email: "clyde@renalware.com",
    password: "supersecret",
    approved: true,
  )
  @clyde.roles << Renalware::Role.find_or_create_by(name: "clinician")
end
