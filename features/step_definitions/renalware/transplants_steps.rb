# Rules: Given code should not go through UI, no matter what the world is

Given(/^Patty has a recipient workup$/) do
  @workup = Renalware::Transplants::RecipientWorkup.create!(
    patient: @patty,
    performed_at: 1.day.ago
  )
end

When(/^Clyde drafts a recipient workup for Patty$/) do
  create_recipient_workup(@clyde, @patty)
end

When(/^Clyde updates the assessment at a given time$/) do
  Timecop.freeze
  update_workup(@workup, @clyde, Time.zone.now)
end

Then(/^Patty has (-?\d+) recipient workup$/) do |count|
  workups = recipient_workups_for(@patty)
  expect(workups.size).to eq(count)
end

Then(/^Patty has a recipient workup updated at that time$/) do
  expect(workups_updated_at(@patty, Time.zone.now).size).to eq(1)
end