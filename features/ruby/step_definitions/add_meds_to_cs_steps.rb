When(/^they add a medication$/) do
  visit medications_patient_path(@patient.id)
end

When(/^complete the medication form$/) do
  select "ESA", :from => "Medication Type"
  select "Blue", :from => "Select Drug"
  fill_in "Dose", :with => "10mg"
  fill_in "Route (PO/IV/SC/IM)", :with => "PO"
  fill_in "Frequency & Duration", :with => "Once daily"
  fill_in "Notes", :with => "Review in six weeks"
  within "#patient_patient_medications_attributes_0_date_3i" do
    select '1'
  end
  within "#patient_patient_medications_attributes_0_date_2i" do
    select 'January'
  end
  within "#patient_patient_medications_attributes_0_date_1i" do
    select '2013'
  end
  click_on "Save Medication"  
end

Then(/^they should see the new medication on the clinical summary$/) do
  expect(page.has_content? "Esa").to be true
  expect(page.has_content? "Blue").to be true
  expect(page.has_content? "10mg").to be true
  expect(page.has_content? "PO").to be true
  expect(page.has_content? "Once daily").to be true
  expect(page.has_content? "2013-01-01").to be true
end
     