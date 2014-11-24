Given(/^that I'm on the add a new drug page$/) do
  visit new_drug_path
end

When(/^I complete the form for a new drug$/) do
  fill_in "Drug Name", with: "I am a new drug"
  select "Immunosuppressant", from: "Type"
  click_on "Save New Drug"
end

Then(/^I should see the new drug on the drugs list$/) do
  expect(page.has_content? "I am a new drug").to be true
  expect(page.has_content? "Immunosuppressant").to be true
end