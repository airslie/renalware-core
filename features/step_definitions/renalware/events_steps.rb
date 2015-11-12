
Given(/^there are existing event types in the database$/) do
  %w(Phone Email Clinic Meeting).each do |name|
    instance_variable_set(:"@#{name.downcase}", FactoryGirl.create(:events_type, name: name))
  end
end

Given(/^Clyde is logged in$/) do
  login_as @clyde
end

Given(/^Clyde is on Patty's event index$/) do
  visit patient_events_path(@patty)
end

When(/^Clyde chooses to add an event$/) do
  click_on "Add event"
end

When(/^records Patty's event$/) do
  fill_in "Date time", with: "20-04-#{Date.current.year} 10:45"

  select "Email", from: "Event type"

  fill_in "Description", with: "Discussed meeting to be set up with family."

  fill_in "Notes", with: "Patty to speak to family before meeting set up."

  click_on "Save"
end

Then(/^Clyde should see Patty's new event on the clinical summary$/) do
  expect(page).to have_content("20/04/#{Date.current.year}")
  expect(page).to have_content("10:45")
  expect(page).to have_content("Email")
  expect(page).to have_content("Discussed meeting to be set up with family.")
  expect(page).to have_content("Patty to speak to family before meeting set up.")
end

Then(/^see Patty's new event in her event index$/) do
  visit patient_events_path(@patty)
  expect(page).to have_content("20/04/#{Date.current.year}")
  expect(page).to have_content("10:45")
  expect(page).to have_content("Email")
  expect(page).to have_content("Discussed meeting to be set up with family.")
  expect(page).to have_content("Patty to speak to family before meeting set up.")
end
