# frozen_string_literal: true

Given("Patty has these allergies") do |table|
  seed_allergies_for(patient: @patty, user: @clyde || @doug, allergies: table.hashes)
end

When("Clyde views add the following allergies to Patty") do |table|
  create_allergies_for(patient: @patty, user: @clyde, allergies: table.hashes)
end

When(/^Clyde removes the "([^"]*)" allergy$/) do |allergy_description|
  remove_allergy_from_patient(patient: @patty,
                              allergy_description: allergy_description,
                              user: @clyde)
end

Then("Patty has the following allergies") do |table|
  expect_allergies_to_be(expected_allergies: table.hashes, patient: @patty)
end

Then("Patty has these archived allergies") do |table|
  expect_archived_allergies_to_be(expected_allergies: table.hashes, patient: @patty)
end

Then("Clyde is able to mark Patty as having No Known Allergies") do
  mark_patient_as_having_no_allergies(patient: @patty, user: @clyde)
end

When("Donna reviews Patty's clinical summary") do
  @clinical_summary = review_clinical_summary(patient: @patty, user: @donna)
end

Then("Donna should see these current prescriptions in the clinical summary") do |table|
  expect_current_prescriptions_to_match(
    Renalware::Medications::SummaryPart.new(@patty).current_prescriptions,
    table.hashes
  )
end

Then("Donna should see these current problems in the clinical summary:") do |table|
  expect_problems_to_match_table(
    Renalware::Problems::SummaryPart.new(@patty).problems,
    table
  )
end
