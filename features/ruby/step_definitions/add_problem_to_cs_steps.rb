When(/^they add a problem$/) do
  click_on "Add a Problem"
end

When(/^complete the problem form$/) do
  fill_in "Add New Problem", :with => "Have abdominal pain, possibly kidney stones"
  click_on "Save Problem"
end

Then(/^they should see the new problem on the clinical summary$/) do
  expect(page.has_content? "Have abdominal pain, possibly kidney stones").to be true
end