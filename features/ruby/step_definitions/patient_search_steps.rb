Given(/^some patients who need renal treatment$/) do
  step "I have a patient in the database"
end

When(/^I search for a patient by hospital centre code$/) do
  visit patients_path
  fill_in "Patient Search", :with => "888"
  click_on "Find Patient"
end

Then(/^they will see a list of matching results for patients$/) do
  expect(page.has_content?("RABBIT")).to be true
end