Given(/^I am on the hello world page$/) do
  visit "http://localhost/~lat/projects/cuke_php/hello_world.php"
end

Then(/^I should see "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end