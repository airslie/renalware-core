When(/^I update the patient's demographics$/) do
  click_on "Edit Demographics"
  fill_in "Forename", :with => "Roger"
  click_on "Update Demographics"
end

Then(/^I should see the patient's new demographics on their profile page$/) do
  expect(page.has_content? "Roger").to be true
end