Given(/^I have some fruits$/) do
  $client.query("INSERT INTO fruits (name, prickly_or_not, colour, \
    country_of_origin) VALUES ('apple', false, 'reddy green', 'GB')")
  binding.pry
end

Given(/^I am on the fruits dashboard$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I view all fruits$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a list of fruits$/) do
  pending # express the regexp above with the code you wish you had
end