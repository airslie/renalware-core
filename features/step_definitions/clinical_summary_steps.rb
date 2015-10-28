Given(/^there are modality reasons in the database$/) do
  @modality_reasons = [
    [nil, nil, "Other"],
    ["PDToHaemodialysis", 111, "Reason One"],
    ["HaemodialysisToPD", 222, "Reason Two"]
  ]
  @modality_reasons.map! do |mr|
    type = mr[0] ? "Renalware::#{mr[0]}" : nil
    @modality_reason = Renalware::ModalityReason.create!(:type => type, :rr_code => mr[1], :description => mr[2])
  end
end

Given(/^there are edta causes of death in the database$/) do
  FactoryGirl.create(:edta_code, code: 100, :death_cause => "Death cause one")
  FactoryGirl.create(:edta_code, code: 200, :death_cause => "Death cause two")
end

Given(/^they are on a patient's clinical summary$/) do
  visit patient_clinical_summary_path(@patient_1)
end

Given(/^there are medication routes in the database$/) do
  @medication_routes = [["PO", "Per Oral"], ["IV", "Intravenous"], ["SC", "Subcutaneous"], ["IM", "Intramuscular"], ["Other (Please specify in notes)", "Other (Refer to notes)"]]
  @medication_routes.map! do |mroute|
    Renalware::MedicationRoute.create!(:name => mroute[0], :full_name => mroute[1])
  end

  @po = @medication_routes[0]
  @iv = @medication_routes[1]
  @sc = @medication_routes[2]
  @im = @medication_routes[3]
  @other_med_route = @medication_routes[4]
end

Given(/^a patient has a medication$/) do
  @medication_one = FactoryGirl.create(:medication,
    patient: @patient_1,
    medicatable: @yellow,
    dose: "10mg",
    medication_route: @iv,
    frequency: "Daily",
    notes: "Must take with food",
    start_date: "#{Date.current.year - 1}-11-01",
    provider: 1
  )

  @medication_two = FactoryGirl.create(:medication,
    patient: @patient_1,
    medicatable: @blue,
    dose: "20ml",
    medication_route: @po,
    frequency: "Twice Weekly",
    notes: "Needs review in 6 months",
    start_date: "#{Date.current.year}-01-02",
    provider: 1
  )

  @patient_1.medications << @medication_one
  @patient_1.medications << @medication_two

end

Given(/^I choose to add a modality$/) do
  visit new_patient_modality_path(@patient_1)
end

When(/^they add a medication$/) do
  visit patient_medications_path(@patient_1)
  click_link "Add a new medication"
end

When(/^complete the medication form by drug type select$/) do
  select "ESA", :from => "Medication Type"
  select "Blue", :from => "Select Drug"
  fill_in "Dose", :with => "10mg"
  select "PO", :from =>  "Route"
  fill_in "Frequency & Duration", :with => "Once daily"
  fill_in "Notes", :with => "Review in six weeks"

  within("#new-form fieldset .row .med-form") do
    select_date("2 March #{Date.current.year - 1}", from: 'Prescribed On')
  end

  click_on "Save Medication"

end

When(/^complete the medication form by drug search$/) do
  visit patient_medications_path(@patient_1)
  click_link "Add a new medication"

  fill_in "Drug", :with => "amo"

  page.execute_script %Q( $('#drug_search').trigger('keydown'); )
  within('.drug-results') do
    expect(page).to have_css("li", :text => "Amoxicillin")
  end

  page.find("#drug-5").click

  fill_in "Dose", :with => "20mg"
  select "IV", :from =>  "Route"
  fill_in "Frequency & Duration", :with => "Twice weekly"
  fill_in "Notes", :with => "Review in two weeks."

  select_date("2 February #{Date.current.year}", from: 'Prescribed On')

  find(:xpath, ".//*[@value='hospital']").set(true)

  click_on "Save Medication"
end

When(/^they terminate a medication$/) do
  visit patient_medications_path(@patient_1)
  find("a.drug-esa").click
  check "Terminate?"
  click_on "Save Medication"
end

When(/^I complete the modality form$/) do

  within "#modality-code-select" do
    select "Modal One"
  end

  select "PD To Haemodialysis", :from => "Type of Change"
  select "Reason One", :from => "Reason for Change"

  select '2014', from: 'modality_started_on_1i'
  select 'December', from: 'modality_started_on_2i'
  select '1', from: 'modality_started_on_3i'

  fill_in "Notes", :with => "Needs wheel chair access"

  click_on "Save"
end

When(/^I select death modality$/) do
  within "#modality-code-select" do
    select "Death"
  end

  select '2015', from: 'modality_started_on_1i'
  select 'April', from: 'modality_started_on_2i'
  select '1', from: 'modality_started_on_3i'

  click_on "Save"
end

When(/^I complete the cause of death form$/) do

  within "#patient_died_on_3i" do
    select '22'
  end
  within "#patient_died_on_2i" do
    select 'September'
  end
  within "#patient_died_on_1i" do
    select '2014'
  end

  select "Death cause one", :from => "EDTA Cause of Death (1)"
  select "Death cause two", :from => "EDTA Cause of Death (2)"

  fill_in "Notes/Details", :with => "Heart stopped"

  click_on "Save Cause of Death"
end

Then(/^they should see the new patient event on the clinical summary$/) do
  %w(01/01/2011, 11:30 Telephone call Spoke to son ).each do |heading|
    expect(page).to have_content(heading), "Expected #{heading} to be in the view"
  end
end

Then(/^be able to view notes through toggling the description data\.$/) do
  expect(page).to have_content("Wants to arrange a home visit")
end

Then(/^they should see the new problems on the clinical summary$/) do
  expect(page).to have_content("Have abdominal pain, possibly kidney stones")
end

Then(/^they should see the new medications on the clinical summary$/) do
  visit patient_clinical_summary_path(@patient_1)

  #drug by select
  within(".drug-esa") do
    expect(page).to have_content("Blue")
    expect(page).to have_content("10mg")
    expect(page).to have_content("PO")
    expect(page).to have_content("Once daily")
    expect(page).to have_content("02/03/#{Date.current.year - 1}")
  end

  #drug by search
  within(".drug-drug") do
    expect(page).to have_content("Amoxicillin")
    expect(page).to have_content("20mg")
    expect(page).to have_content("IV")
    expect(page).to have_content("Twice weekly")
    expect(page).to have_content("02/02/#{Date.current.year}")
  end

end

Then(/^they should no longer see this medication in their clinical summary$/) do
  expect(page).to have_no_content("Blue")
end

Then(/^should see this terminated medication in their medications history$/) do
  visit medications_index_patient_path(@patient)
  expect(page).to have_content?("Blue")
end

Then(/^I should see a patient's modality on their clinical summary$/) do
   expect(page).to have_content("Modal One")
end

Then(/^I should see the date of death and causes of death in the patient's demographics$/) do
  visit patient_path(@patient_1)
  expect(page).to have_content("22/09/2014")
  expect(page).to have_content("Death cause one")
  expect(page).to have_content("Death cause two")
end

Then(/^I should see the patient on the death list$/) do
  visit patient_deaths_path
  within("#patients-deceased") do
    expect(page).to have_content("1000124501")
    expect(page).to have_content("Male")
  end
end

Then(/^I should see the patient's current modality set as death with set date$/) do
  visit patient_modalities_path(@patient_1)

  expect(page).to have_content("Death")
  expect(page).to have_content("01/04/2015")
end

