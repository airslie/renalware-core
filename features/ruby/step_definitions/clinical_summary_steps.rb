Given(/^there are modality reasons in the database$/) do
  @modality_reasons = [[nil, nil, "Other"], ["PdToHaemodialysis", 111, "Reason One"], ["HaemodialysisToPd", 222, "Reason Two"]]
  @modality_reasons.map! do |mr|
    @modality_reason = ModalityReason.create!(:type => mr[0], :rr_code => mr[1], :description => mr[2])
  end
end

Given(/^a patient has a medication$/) do
  @patient_medication_one = PatientMedication.new(medication_id: 2,
    medication_type: "Esa",
    medicatable_id: 2,
    dose: "10mg",
    route: 1,
    frequency: "Daily",
    notes: "Must take with food",
    date: "2014-11-01",
    provider: 1
    )

  @patient_medication_two = PatientMedication.new(medication_id: 2,
    medication_type: "Drug",
    medicatable_id: 1,
    dose: "20ml",
    route: 2,
    frequency: "Twice Weekly",
    notes: "Needs review in 6 months",
    date: "2015-01-02",
    provider: 1
    )
  
  @patient.patient_medications << @patient_medication_one
  @patient.patient_medications << @patient_medication_two

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
  %w(01/01/2011 Telephone call Spoke to son ).each do |heading|
    expect(page.has_content? heading).to be(true), "Expected #{heading} to be in the view"
  end
end

Then(/^be able to view notes through toggling the description data\.$/) do
  expect(page.has_content? "Wants to arrange a home visit").to be(true)
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

Given(/^there are edta causes of death in the database$/) do
  @edta_codes = [[100, "Cause one"], [200, "Cause two"]]
  @edta_codes.map! do |dc|
    @edta_code = EdtaCode.create!(:code => dc[0], :death_cause => dc[1])
  end
end

Given(/^I choose to add a modality$/) do
  visit modality_patient_path(@patient)
end

When(/^I complete the modality form$/) do
 
  within "#modality-code-select" do
    select "Modal One"
  end

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

When(/^I select death modality$/) do
  within "#modality-code-select" do
    select "Death"
  end
end

Then(/^I should complete the cause of death form$/) do
  click_on "Cause of Death"

  within "#patient_death_date_3i" do
    select '22'
  end
  within "#patient_death_date_2i" do
    select 'September'
  end
  within "#patient_death_date_1i" do
    select '2014'
  end

  select "Cause one", :from => "EDTA Cause of Death (1)"
  select "Cause two", :from => "EDTA Cause of Death (2)"

  fill_in "Notes/Details", :with => "Heart stopped"

  click_on "Save Cause of Death"
end

Then(/^see the date of death in the patient's demographics$/) do
  visit demographics_patient_path(@patient)
  expect(page.has_content? "22/09/2014").to be true
end
