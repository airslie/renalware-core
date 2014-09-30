When(/^I fill in the form with my age$/) do
  fill_in "name", :with => "Elle"
  fill_in "age", :with => "17"
end

When(/^submit the form$/) do
  click_on "Submit"
end

Then(/^I should see my age displayed on the page$/) do
  expect(page.has_content?("Elle")).to be true
  expect(page.has_content?("17")).to be true
end