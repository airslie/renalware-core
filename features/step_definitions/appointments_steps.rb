Given(/^the following appointments:$/) do |table|
  table.hashes.each do |row|
    create_appointment(row)
  end
end

When(/^Clyde views the list of appointments$/) do
  @appointments = view_appointments(@clyde)
end

When(/^Clyde sorts the list by patient$/) do
  @appointments = view_appointments(@clyde, q: { s: "patient_family_name asc" })
end

When(/^Clyde sorts the list by user$/) do
  @appointments = view_appointments(@clyde, q: { s: "user_family_name asc" })
end

When(/^Clyde sorts the list by clinic$/) do
  @appointments = view_appointments(@clyde, q: { s: "clinic_name asc" })
end

When(/^Clyde filters the list by date to (\d+\-\d+\-\d+)$/) do |date|
  @appointments = view_appointments(@clyde, q: { starts_at_eq: date })
end

Then(/^Clyde should see these appointments:$/) do |table|
  expect_appointments_to_match(@appointments, table.hashes)
end
