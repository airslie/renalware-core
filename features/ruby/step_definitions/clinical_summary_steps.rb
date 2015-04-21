Given(/^there are modality reasons in the database$/) do
  @modality_reasons = [[nil, nil, "Other"], ["PdToHaemodialysis", 111, "Reason One"], ["HaemodialysisToPd", 222, "Reason Two"]]
  @modality_reasons.map! do |mr|
    @modality_reason = ModalityReason.create!(:type => mr[0], :rr_code => mr[1], :description => mr[2])
  end
end

Given(/^there are medication routes in the database$/) do
  @medication_routes = [["PO", "Per Oral"], ["IV", "Intravenous"], ["SC", "Subcutaneous"], ["IM", "Intramuscular"], ["Other (Please specify in notes)", "Other (Refer to notes)"]]
  @medication_routes.map! do |mroute|
    MedicationRoute.create!(:name => mroute[0], :full_name => mroute[1])
  end
end

Given(/^a patient has a medication$/) do
  @medication_one = Medication.create!(patient_id: @patient_1.id,
    medication_type: @antibiotic.name.downcase,
    medicatable_id: @yellow.id,
    medicatable_type: "Drug",
    dose: "10mg",
    medication_route_id: 2,
    frequency: "Daily",
    notes: "Must take with food",
    date: "2014-11-01",
    provider: 1
    )

  @medication_two = Medication.create!(patient_id: @patient_1.id,
    medication_type: @esa.name.downcase,
    medicatable_id: @blue.id,
    medicatable_type: "Drug",
    dose: "20ml",
    medication_route_id: 1,
    frequency: "Twice Weekly",
    notes: "Needs review in 6 months",
    date: "2015-01-02",
    provider: 1
    )
  
  @patient_1.medications << @medication_one
  @patient_1.medications << @medication_two

end

Given(/^they are on a patient's clinical summary$/) do
  visit clinical_summary_patient_path(@patient_1)
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
  visit problems_patient_path(@patient_1)
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
  visit manage_medications_patient_path(@patient_1)
  click_link "Add a new medication"
end

When(/^complete the medication form$/) do
  select "ESA", :from => "Medication Type"
  select "Blue", :from => "Select Drug"
  fill_in "Dose", :with => "10mg" 
  select "PO", :from =>  "Route"
  fill_in "Frequency & Duration", :with => "Once daily"
  fill_in "Notes", :with => "Review in six weeks"
  within "#patient_medications_attributes_0_date_3i" do
    select '1'
  end
  within "#patient_medications_attributes_0_date_2i" do
    select 'January'
  end
  within "#patient_medications_attributes_0_date_1i" do
    select '2013'
  end

  find("#patient_medications_attributes_0_provider_gp").set(true)

  click_on "Save Medication"
end

When(/^they terminate a medication$/) do
  visit manage_medications_patient_path(@patient_1)
  find("a.drug-esa").click
  check "Terminate?"
  click_on "Save Medication"
end

Then(/^they should see the new patient event on the clinical summary$/) do
  %w(01/01/2011 Telephone call Spoke to son ).each do |heading|
    expect(page).to have_content(heading), "Expected #{heading} to be in the view"
  end
end

Then(/^be able to view notes through toggling the description data\.$/) do
  expect(page).to have_content("Wants to arrange a home visit")
end

Then(/^they should see the new problems on the clinical summary$/) do
  expect(page).to have_content("Have abdominal pain, possibly kidney stones")
  expect(page).to have_content("Bad breath")
end

Then(/^they should see the new medication on the clinical summary$/) do
  visit clinical_summary_patient_path(@patient_1)
  expect(page).to have_css(".drug-esa")
  expect(page).to have_content("Blue")
  expect(page).to have_content("10mg")
  expect(page).to have_content("PO")
  expect(page).to have_content("Once daily")
  expect(page).to have_content("01/01/2013")
end

Then(/^they should no longer see this medication in their clinical summary$/) do
  expect(page).to have_no_content("Blue")
end

Then(/^should see this terminated medication in their medications history$/) do
  visit medications_index_patient_path(@patient)
  expect(page).to have_content?("Blue" )
end

Given(/^there are edta causes of death in the database$/) do
  @edta_codes = [[100, "Cause one"], [200, "Cause two"]]
  @edta_codes.map! do |dc|
    @edta_code = EdtaCode.create!(:code => dc[0], :death_cause => dc[1])
  end
end

Given(/^I choose to add a modality$/) do
  visit new_patient_modality_path(@patient_1)
end

When(/^I complete the modality form$/) do

  within "#modality-code-select" do
    select "Modal One"
  end

  select "PD To Haemodialysis", :from => "Type of Change"
  select "Reason One", :from => "Reason for Change"

  select '2014', from: 'modality_start_date_1i'
  select 'December', from: 'modality_start_date_2i'
  select '1', from: 'modality_start_date_3i'

  fill_in "Notes", :with => "Needs wheel chair access"

  click_on "Save Modality"
end

Then(/^I should see a patient's modality on their clinical summary$/) do
   expect(page).to have_content("Modal One")
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
  visit demographics_patient_path(@patient_1)
  expect(page).to have_content("22/09/2014")
end
