Given(/^I have some fruits$/) do
  $client.query("INSERT INTO fruits (name, prickly_or_not, colour, \
    country_of_origin) VALUES ('apple', false, 'reddy green', 'GB')")
end

Given(/^I am on the fruits dashboard$/) do
  visit "http://localhost:8000/fruits.php"
end

When(/^I view all fruits$/) do
  click_on "View Fruits"
end

Then(/^I should see a list of fruits$/) do
  expect(page.has_content? 'apple').to be true
end