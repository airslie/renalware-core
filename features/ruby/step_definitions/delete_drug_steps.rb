Given(/^I am on the drugs index$/) do
  visit drugs_path
end

When(/^I choose to soft delete a drug$/) do
  find("##{@drug.id}-drug").click
end

Then(/^I should see the drug removed from the drugs list$/) do
  expect(page.has_content? "I am a drug").to be false
end

