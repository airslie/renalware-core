Given(/^(.*?) is a clinician$/) do |name|
  user = Renalware::User.create!(
    first_name: name,
    last_name: "The Clinician",
    username: name,
    email: "#{name}@renalware.com",
    password: "supersecret",
    approved: true,
  )
  user.roles << Renalware::Role.find_or_create_by(name: "clinician")
  instance_variable_set("@"+name.downcase, user)
end
