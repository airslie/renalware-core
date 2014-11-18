Given(/^there are drugs in the database$/) do
  @drugs = [["Red", nil], ["Blue", "Esa"], ["Green", "Immunosuppressant"]]
  @drugs.map! {|d| @drug = Drug.create!(:name => d[0], :type => d[1])}
end

Given(/^that I choose to edit a drug$/) do
  visit edit_drug_path(@drug)
end

When(/^I complete the form for editing a drug$/) do
  fill_in "Drug Name", with: "I am an edited drug"
  select "Immunosuppressant", from: "Type"
  click_on "Update Drug"
end

Then(/^I should see the updated drug on the drugs list$/) do
  expect(page.has_content? "I am an edited drug").to be true
  expect(page.has_content? "Immunosuppressant").to be true
end