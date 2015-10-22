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