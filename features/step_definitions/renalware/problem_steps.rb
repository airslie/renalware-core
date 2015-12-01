Given(/^they go to the problem list page$/) do
  visit patient_problems_path(@patient_1)
end

When(/^they add some problems to the list$/) do
  click_on "Add problem"
  fill_in "Description", with: "Have abdominal pain, possibly kidney stones"
end

When(/^they save the problem list$/) do
  click_on "Save"
end
