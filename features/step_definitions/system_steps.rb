Given(/^Clyde is logged in$/) do
  login_as @clyde
end

Given(/^(.*?) is a clinician$/) do |name|
  user = find_or_create_user(given_name: name, role: "clinician")
  instance_variable_set("@"+name.downcase, user)
end

Given(/^(.*?) is a nurse$/) do |name|
  user = find_or_create_user(given_name: name, role: "clinician")
  instance_variable_set("@"+name.downcase, user)
end
