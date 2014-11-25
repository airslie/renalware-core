Given(/^there are drugs in the database$/) do
  @drugs = [["Red", nil], ["Blue", "Esa"], ["Green", "Immunosuppressant"]]
  @drugs.map! {|d| @drug = Drug.create!(:name => d[0], :type => d[1])}
end

Given(/^that I'm on the add a new drug page$/) do
  visit new_drug_path
end

Given(/^that I choose to edit a drug$/) do
  visit edit_drug_path(@drug)
end

Given(/^I am on the drugs index$/) do
  visit drugs_path
end

When(/^I complete the form for a new drug$/) do
  fill_in "Drug Name", with: "I am a new drug"
  select "Immunosuppressant", from: "Type"
  click_on "Save New Drug"
end

When(/^I complete the form for editing a drug$/) do
  fill_in "Drug Name", with: "I am an edited drug"
  select "Immunosuppressant", from: "Type"
  click_on "Update Drug"
end

When(/^I choose to soft delete a drug$/) do
  find("##{@drug.id}-drug").click
end

Then(/^I should see the new drug on the drugs list$/) do
  expect(page.has_content? "I am a new drug").to be true
  expect(page.has_content? "Immunosuppressant").to be true
end

Then(/^I should see the updated drug on the drugs list$/) do
  expect(page.has_content? "I am an edited drug").to be true
  expect(page.has_content? "Immunosuppressant").to be true
end

Then(/^I should see the drug removed from the drugs list$/) do
  expect(page.has_content? "I am a drug").to be false
end

