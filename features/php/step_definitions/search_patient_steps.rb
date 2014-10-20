Given(/^some patients who need renal treatment$/) do
  $client.query File.read('test/fixtures/patient.sql')
end

Given(/^I've searched for a patient$/) do
  find('#findpatinput').set('RABBIT')
  click_button "Find!"
end

Then(/^they will see a list of matching results$/) do
  expect(page.has_content? "RABBIT").to be true
end