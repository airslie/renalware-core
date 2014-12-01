Given(/^I am on the patients list$/) do
  visit '/lists/patientlist.php'
end

Given(/^I've waited for the indexes to update$/) do
  # not needed in PHP using SQL
end

Given(/^some patients who need renal treatment$/) do
  mysql_client.query File.read('test/fixtures/patient.sql')
end

Given(/^I've searched for a patient$/) do
  find('#findpatinput').set('RABBIT')
  click_button "Find!"
end

When(/^I search for a patient by forename$/) do
  find('#findpatinput').set('Roger')
  click_button "Find!"
end

When(/^I search for a patient by hospital centre code$/) do
  find('#findpatinput').set('Z999999')
  click_button "Find!"
end

When(/^I search for a patient by the first few letters of the surname$/) do
  find('#findpatinput').set('Rab')
  click_button "Find!"
end

When(/^I search for a patient by surname$/) do
  find('#findpatinput').set('rabbit')
  click_button "Find!"
end

Then(/^they will see a list of matching results for patients$/) do
  expect(page.has_content? "RABBIT").to be true
end