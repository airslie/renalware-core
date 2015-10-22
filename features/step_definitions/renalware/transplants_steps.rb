# Rule: Given steps should not go through the UI, no matter what the world is

Given(/^Patty has a recipient workup$/) do
  @workup = Renalware::Transplants::RecipientWorkup.create!(
    patient: @patty
  )
end

Given(/^Don has a donor workup$/) do
  @workup = Renalware::Transplants::DonorWorkup.create!(
    patient: @don,
    document: {
      relationship: {
        donor_recip_relationship: "son_or_daughter"
      }
    }
  )
end

Given(/^Patty is registered on the wait list$/) do
  @registration = Renalware::Transplants::Registration.create!(
    patient: @patty
  )
end

Given(/^Patty is registered on the wait list with this status history$/) do |table|
  @registration = Renalware::Transplants::Registration.create!(
    patient: @patty
  )
  table.hashes.each do |row|
    description = registration_status_description_named(row[:status])
    @registration.statuses.create!(
      description: description,
      started_on: row[:start_date],
      terminated_on: row[:termination_date]
    )
  end
end

When(/^Clyde creates a donor workup for Don$/) do
  create_donor_workup(@clyde, @don)
end

When(/^Clyde creates a recipient workup for Patty$/) do
  create_recipient_workup(@clyde, @patty)
end

When(/^Clyde updates the assessment$/) do
  travel_to 1.hour.from_now
  update_workup(@workup, @clyde, Time.zone.now)
end

When(/^Clyde updates the donor assessment$/) do
  travel_to 1.hour.from_now
  update_donor_workup(@workup, @clyde, Time.zone.now)
end

When(/^Clyde registers Patty on the wait list$/) do
  create_transplant_registration(@clyde, @patty)
end

When(/^Clyde sets the registration status to "(.*?)" and the start date to "(.*?)"$/) do |status, start_date|
  description = registration_status_description_named(status)
  @registration.add_status(description: description, started_on: start_date)
end

When(/^Clyde changes the "(.*?)" start date to "(.*?)"$/) do |status, start_date|
  description = registration_status_description_named(status)
  status = @registration.statuses.where(description_id: description.id).first
  @registration.update_status(status, started_on: start_date)
end

When(/^Clyde deletes the "(.*?)" status change$/) do |status|
  description = registration_status_description_named(status)
  status = @registration.statuses.where(description_id: description.id).first
  @registration.delete_status(status)
end

Then(/^Patty's recipient workup exists$/) do
  expect(recipient_workup_exists(@patty)).to be_truthy
end

Then(/^Patty's recipient workup gets updated$/) do
  expect(workup_was_updated(@patty)).to be_truthy
end

Then(/^Don's donor workup exists$/) do
  expect(donor_workup_exists(@don)).to be_truthy
end

Then(/^Don's donor workup gets updated$/) do
  expect(donor_workup_was_updated(@don)).to be_truthy
end

Then(/^Patty has an active transplant registration$/) do
  expect(transplant_registration_exists(@patty)).to be_truthy
end

Then(/^Clyde can update Patty's transplant registration$/) do
  expect(update_transplant_registration(@registration, @clyde, Time.zone.now)).to be_truthy
end

Then(/^the registration status history is$/) do |table|
  statuses = @registration.reload.statuses.map do |s|
    { status: s.description.name,
      start_date: I18n.l(s.started_on),
      termination_date: (s.terminated_on ? I18n.l(s.terminated_on) : "")
    }.with_indifferent_access
  end
  expect(statuses.size).to eq(table.hashes.size)
  table.hashes.each do |row|
    expect(statuses).to include(row)
  end
end

Then(/^the transplant current status stays "(.*?)" since "(.*?)"$/) do |name, start_date|
  status = @registration.current_status
  expect(status.to_s).to eq(name)
  expect(I18n.l(status.started_on)).to eq(start_date)
end

Then(/^the status history has the following revised termination dates$/) do |table|
  statuses = @registration.reload.statuses.map do |s|
    { status: s.description.name,
      start_date: I18n.l(s.started_on),
      termination_date: (s.terminated_on ? I18n.l(s.terminated_on) : "")
    }.with_indifferent_access
  end
  table.hashes.each do |row|
    expect(statuses).to include(row)
  end
end