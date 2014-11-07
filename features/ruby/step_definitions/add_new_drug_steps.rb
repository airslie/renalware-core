Given(/^that I'm on the add a new drug page$/) do
  visit new_drug_path
end

When(/^I complete the form for a new drug$/) do
  fill_in "New Drug Name", with: "I am a new drug"
  fill_in "Type", with: "Standard"
  click_on "Save New Drug"
end

Then(/^I should see the new drug on the drugs list$/) do
  expect(page.has_content? "I am a new drug").to be true
end