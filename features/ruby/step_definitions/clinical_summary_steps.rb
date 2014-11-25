Given(/^a patient has a medication$/) do
  @patient_medication = PatientMedication.new(medication_id: 2,
    medication_type: "Esa",
    dose: "10mg",
    route: "po",
    frequency: "Daily",
    notes: "Must take with food",
    date: "2014-11-01",
    provider: 1
    )
  @patient.patient_medications << @patient_medication
end

Given(/^they are on a patient's clinical summary$/) do
  visit clinical_summary_patient_path(@patient)
end

When(/^they add a patient event$/) do
  click_on "Add a Patient Event for #{@patient.full_name}"
end

When(/^complete the patient event form$/) do

  within "#patient_event_date_time_3i" do
    select '1'
  end
  within "#patient_event_date_time_2i" do
    select 'January'
  end
  within "#patient_event_date_time_1i" do
    select '2011'
  end

  within "#patient_event_date_time_4i" do
    select '11'
  end
  within "#patient_event_date_time_5i" do
    select '30'
  end

  fill_in "Entered by", :with => "evaliant"

  select "Telephone call", from: "Patient Event Type"

  fill_in "Description", :with => "Spoke to Son"
  fill_in "Notes", :with => "Wants to arrange a home visit"

  click_on "Save Patient Event"
end

When(/^they add a problem$/) do
  click_on "Add a Problem"
end

When(/^complete the problem form$/) do
  fill_in "Add New Problem", :with => "Have abdominal pain, possibly kidney stones"
  click_on "Save Problem"
end

When(/^they add a medication$/) do
  visit medications_patient_path(@patient.id)
  click_link "Add a new medication"
end

When(/^complete the medication form$/) do
  select "ESA", :from => "Medication Type"
  select "Blue", :from => "Select Drug"
  fill_in "Dose", :with => "10mg"
  select "PO", :from =>  "Route"
  fill_in "Frequency & Duration", :with => "Once daily"
  fill_in "Notes", :with => "Review in six weeks"
  within "#patient_patient_medications_attributes_0_date_3i" do
    select '1'
  end
  within "#patient_patient_medications_attributes_0_date_2i" do
    select 'January'
  end
  within "#patient_patient_medications_attributes_0_date_1i" do
    select '2013'
  end

  find("#patient_patient_medications_attributes_0_provider_gp").set(true)

  click_on "Save Medication"
end

When(/^they terminate a medication$/) do
  visit medications_patient_path(@patient)
  find("a.drug-esa").click  
  check "Terminate?"
  click_on "Save Medication"
end

Then(/^they should see the new patient event on the clinical summary$/) do
  %w(Telephone call Added Event Type User Modal Description Time Entered By).each do |heading|
    expect(page.has_content? heading).to be(true), "Expected #{heading} to be in the view"
  end

  expect(page.has_content? "2011-01-01").to be true
  expect(page.has_content? "Telephone call").to be true
  expect(page.has_content? "11:30").to be true
  expect(page.has_content? "Spoke to Son").to be true
end

Then(/^they should see the new problem on the clinical summary$/) do
  expect(page.has_content? "Have abdominal pain, possibly kidney stones").to be true
end

Then(/^they should see the new medication on the clinical summary$/) do
  expect(page.has_css? ".drug-esa").to be true
  expect(page.has_content? "Blue").to be true
  expect(page.has_content? "10mg").to be true
  expect(page.has_content? "PO").to be true
  expect(page.has_content? "Once daily").to be true
  expect(page.has_content? "2013-01-01").to be true
end

Then(/^they should no longer see this medication in their clinical summary$/) do
  expect(page.has_content? "Blue").to be false
end

# Then(/^should see this terminated medication in their medications history$/) do
#   visit medications_index_patient_path(@patient)
#   expect(page.has_content? "Blue" ).to be true
# end
