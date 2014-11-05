When(/^they delete a patient event type$/) do
  find("##{@pet.id}-pet").click
end

Then(/^they should see the deleted event type removed from the existing event type list$/) do
  expect(page.has_content? "Meeting with family").to be false
end
