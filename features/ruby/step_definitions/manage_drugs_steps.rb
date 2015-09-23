Given(/^there are drugs in the database$/) do
  %w(Red Blue Yellow Green Amoxicillin Cephradine Dicloxacillin Metronidazole Penicillin Rifampin Tobramycin Vancomycin).each do |name|
    instance_variable_set(:"@#{name.downcase}", FactoryGirl.create(:drug, :name => name))
  end
end

Given(/^there are drug types in the database$/) do
  %w(Antibiotic ESA Immunosuppressant Peritonitis).each do |dt|
    instance_variable_set(:"@#{dt.downcase}", FactoryGirl.create(:drug_type, :name => dt))
  end
end

Given(/^existing drugs have been assigned drug types$/) do
  @drug_drug_type_1  = Renalware::DrugDrugType.create!(drug_id: @red.id, drug_type_id: @immunosuppressant.id)
  @drug_drug_type_2  = Renalware::DrugDrugType.create!(drug_id: @blue.id, drug_type_id: @esa.id)
  @drug_drug_type_3  = Renalware::DrugDrugType.create!(drug_id: @yellow.id, drug_type_id: @immunosuppressant.id)
  @drug_drug_type_5  = Renalware::DrugDrugType.create!(drug_id: @green.id, drug_type_id: @esa.id)
  @drug_drug_type_6  = Renalware::DrugDrugType.create!(drug_id: @amoxicillin.id, drug_type_id: @antibiotic.id)
  @drug_drug_type_7  = Renalware::DrugDrugType.create!(drug_id: @amoxicillin.id, drug_type_id: @peritonitis.id)
  @drug_drug_type_8  = Renalware::DrugDrugType.create!(drug_id: @cephradine.id, drug_type_id: @antibiotic.id)
  @drug_drug_type_9  = Renalware::DrugDrugType.create!(drug_id: @cephradine.id, drug_type_id: @peritonitis.id)
  @drug_drug_type_10 = Renalware::DrugDrugType.create!(drug_id: @dicloxacillin.id, drug_type_id: @antibiotic.id)
  @drug_drug_type_11 = Renalware::DrugDrugType.create!(drug_id: @dicloxacillin.id, drug_type_id: @peritonitis.id)
  @drug_drug_type_12 = Renalware::DrugDrugType.create!(drug_id: @metronidazole.id, drug_type_id: @antibiotic.id)
  @drug_drug_type_13 = Renalware::DrugDrugType.create!(drug_id: @metronidazole.id, drug_type_id: @peritonitis.id)
  @drug_drug_type_14 = Renalware::DrugDrugType.create!(drug_id: @penicillin.id, drug_type_id: @antibiotic.id)
  @drug_drug_type_15 = Renalware::DrugDrugType.create!(drug_id: @penicillin.id, drug_type_id: @peritonitis.id)
  @drug_drug_type_16 = Renalware::DrugDrugType.create!(drug_id: @rifampin.id, drug_type_id: @antibiotic.id)
  @drug_drug_type_17 = Renalware::DrugDrugType.create!(drug_id: @rifampin.id, drug_type_id: @peritonitis.id)
  @drug_drug_type_18 = Renalware::DrugDrugType.create!(drug_id: @tobramycin.id, drug_type_id: @antibiotic.id)
  @drug_drug_type_19 = Renalware::DrugDrugType.create!(drug_id: @tobramycin.id, drug_type_id: @peritonitis.id)
  @drug_drug_type_20 = Renalware::DrugDrugType.create!(drug_id: @vancomycin.id, drug_type_id: @antibiotic.id)
  @drug_drug_type_21 = Renalware::DrugDrugType.create!(drug_id: @vancomycin.id, drug_type_id: @peritonitis.id)
end

Given(/^that I'm on the add a new drug page$/) do
  visit new_drug_path
end

Given(/^that I choose to edit a drug$/) do
  visit edit_drug_path(@vancomycin)
end

Given(/^I am on the drugs index$/) do
  visit drugs_path
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
  find("##{@vancomycin.id}-drug").click
end

Then(/^I should see the new drug on the drugs list$/) do
  expect(page).to have_content("I am a new drug")
end

Then(/^I should see the new drug's categories\/types$/) do
  visit drug_drug_drug_types_path(Renalware::Drug.all.fourth)
  expect(page).to have_content("Antibiotic")
  expect(page).to have_content("Immunosuppressant")
end

Then(/^I should see the updated drug on the drugs list$/) do
  expect(page).to have_content("I am an edited drug")

  visit drug_drug_drug_types_path(@vancomycin)
  page.assert_selector('li', :text => 'Antibiotic', :count => 1)
  page.assert_selector('li', :text => 'Peritonitis', :count => 0)
end

Then(/^I should see the drug removed from the drugs list$/) do
  expect(page).to have_no_content("Vancomycin")
end


