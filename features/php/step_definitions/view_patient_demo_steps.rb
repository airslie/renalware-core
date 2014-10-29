Given(/^I have a patient in the database$/) do
  mysql_client.query File.read('test/fixtures/patient.sql')
end

Given(/^I've selected the patient from the search results$/) do
  click_on "RABBIT, R"
  click_on "Admin"
end

Then(/^I should see the patient's demographics on their profile page$/) do
  expect(page.has_content? "PATIENT DEMOGRAPHICS").to be true
  expect(page.has_content? "1000124502").to be true
  expect(page.has_content? "Mr").to be true
  expect(page.has_content? "RABBIT").to be true
  expect(page.has_content? "R").to be true
  expect(page.has_content? "M").to be true
  expect(page.has_content? "01/01/1947").to be true
end