Given(/^Patty has a letter$/) do
  set_up_simple_letter_for(@patty, user: @nathalie)
end

Given(/^Patty accepted to be CCd on all letters$/) do
  @patty.update_attribute(:cc_on_all_letters, true)
end

Given(/^Patty is the main recipient on a pending letter$/) do
  @letter = set_up_simple_letter_for(@patty, user: @nathalie)
end

Given(/^a letter for Patty's clinical visit was drafted$/) do
  @letter = seed_clinic_visit_letter_for(@patty, user: @nathalie)
end


When(/^Nathalie drafts a letter for Patty to "(.*?)" with "(.*?)"$/) do |rec, ccs|
  recipient = letter_recipients_map.fetch(rec)
  cc_recipients = ccs.split(",").map { |cc| letter_recipients_map.fetch(cc.strip) }

  draft_simple_letter(patient: @patty, user: @nathalie, issued_on: Time.zone.today,
    recipient: recipient, ccs: cc_recipients
  )
end

When(/^Nathalie drafts an erroneous letter$/) do
  draft_simple_letter(patient: @patty, user: @nathalie, issued_on: nil,
    recipient: @patty
  )
end

When(/^Doug drafts a clinic letter for Patty$/) do
  draft_clinic_visit_letter(patient: @patty, user: @nathalie, issued_on: Time.zone.today)
end

When(/^Doug drafts an erroneous clinic visit letter$/) do
  draft_clinic_visit_letter(patient: @patty, user: @nathalie, issued_on: nil)
end

When(/^Nathalie updates Patty's address$/) do
  update_patient_address(patient: @patty, current_address_attributes: { street_1: "new street 1" })
end

When(/^Nathalie marks the letter typed$/) do
  mark_draft_as_typed(patient: @patty, user: @nathalie)
end


Then(/^"(.*?)" will receive the letter$/) do |recipient|
  expect_simple_letter_to_exist(@patty, recipient: letter_recipients_map.fetch(recipient))
end

Then(/^Nathalie can revise Patty's letter$/) do
  revise_simple_letter(patient: @patty, user: @nathalie)
end

Then(/^Doug can revise Patty's clinic visit letter$/) do
  revise_clinic_visit_letter(patient: @patty, user: @nathalie)
end

Then(/^the letter is not drafted$/) do
  expect_letter_to_be_refused
end

Then(/^all "(.*?)" will also receive the letter$/) do |ccs|
  cc_recipients = ccs.split(",").map do |cc|
    letter_recipients_map.fetch(cc.strip)
  end
  expect_simple_letter_to_have_ccs(@patty, ccs: cc_recipients)
end

Then(/^Patty's pending letter is addressed to her new address$/) do
  expect_letter_to_be_addressed_to(
    letter: @letter.reload,
    address_attributes: { street_1: "new street 1" }
  )
end

Then(/^Doug can review the letter$/) do
  expect_doctor_can_review_letter(patient: @patty, doctor: @doug)
end

Then(/^a letter for Patty's clinical visit is drafted$/) do
  expect_clinic_visit_letter_to_exist(patient: @patty)
end

Then(/^the letter lists Patty's current medications$/) do
  expect_letter_to_list_current_medications(patient: @patty)
end

Then(/^the letter lists Patty's clinical observations$/) do
  expect_letter_to_list_clinical_observations(patient: @patty)
end

Then(/^the letter lists Patty's problems$/) do
  expect_letter_to_list_problems(patient: @patty)
end


