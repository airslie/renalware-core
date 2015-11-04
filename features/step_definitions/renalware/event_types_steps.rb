
Given(/^there are existing event types in the database$/) do
  %w(Home Clinic Phone Email).each do |name|
    instance_variable_set(:"@#{name.downcase}", FactoryGirl.create(:events_type, name: name))
  end
end

Given(/^they choose to add a new event type$/) do
  visit new_events_type_path
end

Given(/^they complete the new event form$/) do
  fill_in "Event Type", with: "New type of event"
  click_on "Save"
end

Then(/^they should see the new event type added to the event types index$/) do
  expect(page).to have_content("New type of event")
end

Given(/^they visit the event types index$/) do
  visit events_types_path
end

When(/^they choose to edit an event type$/) do
  visit edit_events_type_path(@email)
end

When(/^complete the event type form$/) do
  fill_in "Event Type", with: "Holiday Email"
  click_on "Update"
end

Then(/^they should see the updated event type in the event types index$/) do
  expect(page).to have_content("Holiday Email")
end

When(/^they choose to soft delete a event type$/) do
  find("##{@clinic.id}-event-type").click
end

Then(/^they should see this event type removed from the event types index$/) do
  expect(page).to_not have_content("Clinic")
end