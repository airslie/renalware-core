When(/^Clyde drafts a recipient workup for Patty$/) do
  create_recipient_workup(@clyde, @patty)
end

Then(/^Patty has (-?\d+) recipient workup$/) do |count|
  workups = recipient_workups_for(@patty)
  expect(workups.size).to eq(count)
end