Given(/^A person exists in the directory$/) do
  seed_person(user: Renalware::User.first)
end

Given(/^these people were recorded:$/) do |table|
  seed_people(table)
end

When(/^Clyde adds a person to the directory$/) do
  create_person(user: @clyde)
end

When(/^Clyde adds an erroneous person to the directory$/) do
  create_person(user: @clyde, attributes: { given_name: nil })
end

When(/^Clyde searches for the Rabbit family members$/) do
  view_people(q: {
      family_name_or_given_name_cont: "Rabbit"
    },
    user: @clyde
  )
end

When(/^Clyde searches for people with Roger as the given name$/) do
  view_people(q: {
      family_name_or_given_name_cont: "Roger"
    },
    user: @clyde
  )
end

Then(/^the directory includes the person$/) do
  expect_person_to_exist
end

Then(/^the person is not accepted$/) do
  expect_person_to_be_refused
end

Then(/^Clyde can update the person$/) do
  update_person(user: @clyde)
end

Then(/^Clyde views these people:$/) do |table|
  expect_people_to_be(table)
end