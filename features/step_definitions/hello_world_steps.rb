Given(/^I am on the hello world page$/) do
  visit "http://localhost:8000/php/hello_world.php"
end

Then(/^I should see "(.*?)"$/) do |hello|
  expect(page.has_content?(hello)).to be true
end

