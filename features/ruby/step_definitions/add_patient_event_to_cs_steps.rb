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

Then(/^they should see the new patient event on the clinical summary$/) do
  %w(Telephone call Added Event Type User Modal Description Time Staff Name).each do |heading|
    expect(page.has_content? heading).to be(true), "Expected #{heading} to be in the view"
  end

  expect(page.has_content? "2011-01-01").to be true
  expect(page.has_content? "Telephone call").to be true
  expect(page.has_content? "11:30").to be true
  expect(page.has_content? "Spoke to Son").to be true
end