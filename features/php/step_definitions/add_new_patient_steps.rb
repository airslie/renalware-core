Given(/^I am on the add a new patient page$/) do
  visit "/pat/addpatient.php"
end

Given(/^I've searched for a patient in the database$/) do
  find('#surname').set('Smith')
  click_button "Search Renalware Patients"
end

When(/^I complete the add a new patient form$/) do
  all('[name=patsite]')[1].click
  fill_in "KCH No", :with => "Z999998"
  fill_in "NHS No", :with => " 1000124503"
  select('Mr', :from => 'Title')
  fill_in "last name", :with => "Smith"
  fill_in "first names", :with => "Ian"
  select('Male', :from => 'sex')
  within "#dob_day" do
    select '13'
  end
  within "#dob_month" do
    select '01 -- Jan'
  end
  within "#dob_year" do
    select '1960'
  end
  select('Married', :from => 'marit status')
  select('White', :from => 'ethnicity')
  click_on "add new patient"
end

Then(/^I should see the new patient in the Renal Patient List$/) do
  visit "/lists/patientlist.php"
  expect(page.has_content? "SMITH").to be true
end

Then(/^the patient should be created$/) do
  expect(mysql_client.query("SELECT COUNT(*) FROM patientdata").count).to eq(1)
end