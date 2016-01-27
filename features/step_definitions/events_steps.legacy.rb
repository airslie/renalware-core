Given(/^Clyde is on Patty's event index$/) do
  visit patient_events_path(@patty)
end

When(/^Clyde chooses to add an event$/) do
  click_on "Add event"
end

When(/^records Patty's event$/) do
  fill_in_date_time "Date time", with: fake_date_time
  select "Email", from: "Event type"
  fill_in "Description", with: "Discussed meeting to be set up with family."
  fill_in "Notes", with: "Patty to speak to family before meeting set up."
  click_on "Save"
end

Then(/^Clyde should see Patty's new event on the clinical summary$/) do
  expect(page).to have_content(fake_date)
  expect(page).to have_content(fake_time)
  expect(page).to have_content("Email")
  expect(page).to have_content("Discussed meeting to be set up with family.")
  expect(page).to have_content("Patty to speak to family before meeting set up.")
end

Then(/^see Patty's new event in her event index$/) do
  visit patient_events_path(@patty)

  expect(page).to have_content(fake_date)
  expect(page).to have_content(fake_time)
  expect(page).to have_content("Email")
  expect(page).to have_content("Discussed meeting to be set up with family.")
  expect(page).to have_content("Patty to speak to family before meeting set up.")
end
