Given(/^there is a patient$/) do
  mysql_client.query File.read('test/fixtures/patient.sql')
end

Given(/^there are ethnicities in the database$/) do
  File.read('test/fixtures/ethnicities.sql').each_line do |sql|
    mysql_client.query sql
  end
end

Given(/^there are existing patient event types in the database$/) do
  # Not needed in PHP - hard coded in the view
end

Given(/^they are on a patient's clinical summary$/) do
   visit '/pat/patient.php?vw=clinsumm&zid=124502'
end

When(/^they add a patient event$/) do
  click_on 'Encs'
  click_on 'add new encounter'
end

When(/^complete the patient event form$/) do
  fill_in "Encounter Date", :with => "20/10/2014"
  fill_in "Entered by", :with => "daniel"
  select('Home visit', :from => 'Encounter type')
  fill_in "Description", :with => "Assessing treatment"
  fill_in "Notes", :with => "Needs check up"
  fill_in "BP", :with => "40/60"
  fill_in "Weight", :with => "60"
  fill_in "Height", :with => "1.8"
  click_on "add encounter"
end

Then(/^they should see the new patient event on the clinical summary$/) do
  expect(page.has_content? "Home visit").to be true
  %w(added enc date user modal description time staffname).each do |heading|
    expect(page.has_content? heading).to be(true), "Expected #{heading} to be in the view"
  end
end

When(/^they add a problem$/) do
  click_on "Probs"
  click_on "Add problem(s)"
end

When(/^complete the problem form$/) do
  fill_in "problemblock", :with => "Has a toothache"
  click_on "add new problem(s)"
end

Then(/^they should see the new problem on the clinical summary$/) do
  expect(page.has_content? "Has a toothache").to be true
end

When(/^they add a medication$/) do
  click_on "Edit Meds"
  fill_in "Drug name/inits", :with => "beta"
  click_on "Add Med"
end

When(/^complete the medication form$/) do
  select('Beta-Carotene Capsules', :from => 'drugid_name')
  fill_in "Dose", :with => "10mg"
  fill_in "Route (PO/IV/SC/IM)", :with => "PO"
  fill_in "Frequency & Duration", :with => "Once daily"
  fill_in "Notes", :with => "Review in six weeks"
  fill_in "date added", :with => "20/10/2014"
  all('[name=provider]')[1].click
  click_on "Add new drug"
end

Then(/^they should see the new medication on the clinical summary$/) do
  expect(page.has_content? "Beta-Carotene Capsules").to be true
  expect(page.has_content? "10mg").to be true
  expect(page.has_content? "Once daily").to be true
end
