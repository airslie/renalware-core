When(/^I update the patient's demographics$/) do
  click_on "Edit Admin Info"
  fill_in "firstnames", :with => "Roger"
  click_on "UPDATE PATIENT INFO"
end

Then(/^I should see the patient's new demographics on their profile page$/) do
  expect(page.has_content? "Roger").to be true
end