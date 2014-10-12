Given(/^I select the HD screen$/) do
  click_link 'HD profile/sessions'
end

Given(/^I select the HD perscription$/) do
  # TODO I think I'm testing slightly the wrong thing here... but you get the
  # idea
  click_on "add new HD Session"
end

Given(/^I complete the form$/) do
  find("select[name='sitecode']").select 'Dartford'
  find("select[name='access']").select 'fistula - radial (L)'
  find("input[name='timeon']").set '10:00'
  # etc etc...
  click_on "add new session for R RABBIT"
end

Then(/^a nurse sees the HS perscription$/) do
  expect(page.has_content? 'fistula - radial (L)').to be true
end

Then(/^I should be on the HS screen$/) do
  expect(page.has_content? 'add new HD Session').to be true
end
