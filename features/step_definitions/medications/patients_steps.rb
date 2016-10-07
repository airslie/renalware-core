Given(/^these patients and prescriptions$/) do |table|
  seed_prescriptions(table)
end

When(/^Nancy views the ESA patients list$/) do
  view_esa_prescriptions(user: @nancy)
end

Then(/^Nancy sees only these patients$/) do |table|
  expect_prescriptions_to_be(table)
end
