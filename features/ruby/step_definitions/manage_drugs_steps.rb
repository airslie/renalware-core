Given(/^there are drugs in the database$/) do
  @drugs = ["Red", "Blue", "Green"]
  @drugs.map! { |d| @drug = Drug.create!(:name => d )}
end

Given(/^there are drug types in the database$/) do
  @drug_types = ["Antibiotic", "ESA", "Immunosuppressant", "Peritonitis"]
  @drug_types.map! { |dt| DrugType.create!(:name => dt)}
end

Given(/^existing drugs have been assigned a drug type$/) do
  @drug_drug_type_1 = @drugs[0].drug_drug_types.build(drug_type_id: @drug_types[1].id).save!
  @drug_drug_type_2 = @drugs[1].drug_drug_types.build(drug_type_id: @drug_types[1].id).save!
  @drug_drug_type_3 = @drugs[2].drug_drug_types.build(drug_type_id: @drug_types[0].id).save!
  @drug_drug_type_4 = @drugs[2].drug_drug_types.build(drug_type_id: @drug_types[3].id).save!  
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
  expect(page.has_content? "Green").to be false
end


