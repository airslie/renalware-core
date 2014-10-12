Given(/^some patients who need renal treatment$/) do
  $client.query File.read('test/fixtures/patient.sql')
end

Given(/^I've searched for a patient$/) do
  find('#findpatinput').set('RABBIT')
  click_button "Find!"
end

Given(/^I've selected the patient from the search results$/) do
  click_link 'RABBIT, R'
end
