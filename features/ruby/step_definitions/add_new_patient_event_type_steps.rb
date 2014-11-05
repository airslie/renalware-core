Given(/^they are adding a new patient event$/) do
  visit new_patient_event_path
end

When(/^they add a new patient event type$/) do
  click_on "Add a New Event Type"
end

When(/^they complete the add a new patient event type form$/) do
  fill_in "New Patient Event Type", :with => "I am a new patient event type"
  click_on "Save New Patient Event Type"
end

Then(/^they should see the new patient event type added to the patient event type list$/) do
  expect(page.has_content? "I am a new patient event type").to be true
end
