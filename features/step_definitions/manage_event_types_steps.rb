Given(/^they are adding a new patient event$/) do
  visit new_event_path
end

Given(/^they are on the existing patient event types page$/) do
  visit event_types_path
end

Given(/^there are existing patient event types in the database$/) do
  @event_types = ["Telephone call", "Email", "Meeting with family"]
  @event_types.map { |t| @pet = Renalware::Events::Type.create!(name: t) }
end

When(/^they edit a patient event type$/) do
  visit edit_event_type_path(@pet)
end

When(/^they complete the edit patient event type form$/) do
  fill_in "New Patient Event Type", :with => "I am an updated new patient event"
  click_on "Update Patient Event Type"
end

When(/^they add a new patient event type$/) do
  click_on "Add a New Event Type"
end

When(/^they complete the add a new patient event type form$/) do
  fill_in "New Patient Event Type", :with => "I am a new patient event type"
  click_on "Save New Patient Event Type"
end

When(/^they delete a patient event type$/) do
  find("##{@pet.id}-pet").click
end

Then(/^they should see the deleted event type removed from the existing event type list$/) do
  expect(page).to have_no_content("Meeting with family")
end

Then(/^they should see the new patient event type added to the patient event type list$/) do
  expect(page).to have_content?("I am a new patient event type")
end

Then(/^they should see the updated event type on the existing patient event type list$/) do
  expect(page).to have_content?("I am an updated new patient event")
end
