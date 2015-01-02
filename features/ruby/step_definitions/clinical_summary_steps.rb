Given(/^there are modality reasons in the database$/) do
  @modality_reasons = [[nil, nil, "Other"], ["PdToHaemodialysis", 111, "Reason One"], ["HaemodialysisToPd", 222, "Reason Two"]]
  @modality_reasons.map! do |mr|
    @modality_reason = ModalityReason.create!(:type => mr[0], :rr_code => mr[1], :description => mr[2])
  end
end

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
  click_on "Add Patient Event"
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

  select "Telephone call", from: "Patient Event Type"

  fill_in "Description", :with => "Spoke to Son"
  fill_in "Notes", :with => "Wants to arrange a home visit"

  click_on "Save Patient Event"
end

Given(/^they go to the problem list page$/) do
  visit problems_patient_path(@patient)
end

When(/^they add some problems to the list$/) do
  click_on "Add a new problem"
  fill_in "Description", :with => "Have abdominal pain, possibly kidney stones"
  click_on "Add another problem"
  all(".probs-description")[1].set "Bad breath"
end

When(/^they save the problem list$/) do
  click_on "Save Problems"
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

  expect(page.has_content? "01/01/2011").to be true
  expect(page.has_content? "Telephone call").to be true
  expect(page.has_content? "11:30").to be true
  expect(page.has_content? "Spoke to Son").to be true
end

Then(/^they should see the new problems on the clinical summary$/) do
  expect(page.has_content? "Have abdominal pain, possibly kidney stones").to be true
  expect(page.has_content? "Bad breath").to be true
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

Given(/^I choose to add a modality$/) do
  visit modality_patient_path(@patient)
end

When(/^I complete the modality form$/) do

  select "Modal One", :from => "Modality"
  select "PD To Haemodialysis", :from => "Type of Change"
  select "Reason One", :from => "Reason for Change"

  within "#patient_patient_modality_attributes_date_3i" do
    select '1'
  end
  within "#patient_patient_modality_attributes_date_2i" do
    select 'December'
  end
  within "#patient_patient_modality_attributes_date_1i" do
    select '2014'
  end

  fill_in "Notes", :with => "Needs wheel chair access"

  click_on "Save Modality"
end

Then(/^I should see a patient's modality on their clinical summary$/) do
   expect(page.has_content? "Modal One").to be true
end
