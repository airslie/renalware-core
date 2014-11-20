Given(/^a patient has a medication$/) do
  @patient_medication = @patient.patient_medications.build(medication_id: 2, 
    medication_type: "Esa", 
    dose: "10mg", 
    route: "PO",
    frequency: "Daily", 
    notes: "Must take with food", 
    date: "2014-11-01",
    provider: 1
    )
end

When(/^they terminate a medication$/) do
  visit medications_patient_path(@patient)
  check('Terminate?')
end

Then(/^they should no longer see this medication in their clinical summary$/) do
  expect(page.has_content? "Blue").to be false
end

# Then(/^should see this terminated medication in their medications history$/) do
#   visit medications_index_patient_path(@patient)
#   expect(page.has_content? "Blue" ).to be true
# end