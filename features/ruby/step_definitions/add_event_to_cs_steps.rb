Given(/^they are on a patient's clinical summary$/) do
  visit clinical_summary_patient_path(@patient)
end

When(/^they add an event$/) do
  click_on "Add an Event"
end

When(/^complete the encounter form$/) do
  within "#event_enc_date_1i" do
    select '2011'
  end
  within "#event_enc_date_2i" do
    select 'January'
  end
  within "#event_enc_date_3i" do
    select '1'
  end

  fill_in "Entered by", :with => "evaliant"
  fill_in "Encounter Type", :with => "Telephone call"
  fill_in "Description", :with => "Spoke to Son"
  fill_in "Notes", :with => "Wants to arrange a home visit"

  click_on "Save Event"
end

Then(/^they should see the new event on the clinical summary$/) do
  expect(page.has_content? "2011-01-01").to be true
  expect(page.has_content? "Spoke to Son").to be true
end