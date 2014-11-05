Given(/^they are on the existing patient event types page$/) do
  visit patient_event_types_path
end

Given(/^there are existing patient event types in the database$/) do
  @patient_event_types = ["Telephone call", "Email", "Meeting with family"]
  @patient_event_types.map { |t| @pet = PatientEventType.create!(:name => t) }
end

When(/^they edit a patient event type$/) do
  visit edit_patient_event_type_path(@pet)
end

When(/^they complete the edit patient event type form$/) do
  fill_in "New Patient Event Type", :with => "I am an updated new patient event"
  click_on "Update Patient Event Type"
end

Then(/^they should see the updated event type on the existing patient event type list$/) do
  expect(page.has_content? "I am an updated new patient event").to be true
end
