Given(/^there are drugs in the database$/) do
  %w(Red Blue Yellow Green Amoxicillin Cephradine Dicloxacillin Metronidazole Penicillin Rifampin Tobramycin Vancomycin).each do |name|
    instance_variable_set(:"@#{name.downcase}", FactoryGirl.create(:drug, :name => name))
  end
end

Given(/^there are drug types in the database$/) do
  %w(Antibiotic ESA Immunosuppressant Peritonitis).each do |dt|
    drug_type = FactoryGirl.create(:drug_type, code: dt.downcase, name: dt)
    instance_variable_set(:"@#{dt.downcase}", drug_type)
  end
end

Given(/^existing drugs have been assigned drug types$/) do
  @red.drug_types << @immunosuppressant
  @blue.drug_types << @esa
  @yellow.drug_types << @immunosuppressant
  @green.drug_types << @esa
  @amoxicillin.drug_types << @antibiotic
  @amoxicillin.drug_types << @peritonitis
  @cephradine.drug_types << @antibiotic
  @cephradine.drug_types << @peritonitis
  @dicloxacillin.drug_types << @antibiotic
  @dicloxacillin.drug_types << @peritonitis
  @metronidazole.drug_types << @antibiotic
  @metronidazole.drug_types << @peritonitis
  @penicillin.drug_types << @antibiotic
  @penicillin.drug_types << @peritonitis
  @rifampin.drug_types << @antibiotic
  @rifampin.drug_types << @peritonitis
  @tobramycin.drug_types << @antibiotic
  @tobramycin.drug_types << @peritonitis
  @vancomycin.drug_types << @antibiotic
  @vancomycin.drug_types << @peritonitis
end

Given(/^that I'm on the add a new drug page$/) do
  visit new_drugs_drug_path
end

Given(/^that I choose to edit a drug$/) do
  @edited_drug = Renalware::Drugs::Drug.first!
  visit edit_drugs_drug_path(@edited_drug)
end

Given(/^I am on the drugs index$/) do
  visit drugs_drugs_path
end

When(/^I complete the form for a new drug$/) do
  fill_in "Drug Name", with: "I am a new drug"
  check "Antibiotic"
  check "Immunosuppressant"
  click_on "Save"
end

When(/^I complete the form for editing a drug$/) do
  fill_in "Drug Name", with: "I am an edited drug"
  uncheck('Peritonitis')
  click_on "Update"
end

When(/^I choose to soft delete a drug$/) do
  @deleted_drug = Renalware::Drugs::Drug.ordered.first!
  find("##{@deleted_drug.id}-drug").click
end

Then(/^I should see the new drug on the drugs list$/) do
  drug = Renalware::Drugs::Drug.find_by(name: "I am a new drug")
  expect(drug).to be_present
end

Then(/^I should see the updated drug on the drugs list$/) do
  expect(@edited_drug.reload.name).to eq("I am an edited drug")
end

Then(/^I should see the drug removed from the drugs list$/) do
  expect(page).to have_no_content("Vancomycin")
end

When(/^I search for a drug by name$/) do
  fill_in "Drug", :with => "Red"

  page.execute_script %Q($('.find_drug').trigger('keyup'))
end

Then(/^they should see the list of drugs listed in the dropdown$/) do
  within('#new-form .drug-results') do
    expect(page).to have_css("li", :text => "Red")
  end
end
