Given(/^Patty has a letter$/) do
  set_up_simple_letter_for(@patty, user: @nathalie)
end

Given(/^Patty accepted to be CCd on all letters$/) do
  @patty.update_attribute(:cc_on_all_letters, true)
end


When(/^Nathalie drafts a letter for Patty to "(.*?)" with "(.*?)" in CC$/) do |rec, ccs|
  map = {
    "herself" => @patty,
    "her doctor" => @patty.doctor,
    "John Doe in London" => { name: "John Doe", city: "London" }
  }

  recipient = map[rec]
  cc_recipients = ccs.split(",").map { |cc| map[cc.strip] }

  create_simple_letter(patient: @patty, user: @nathalie, issued_on: Time.zone.today,
    recipient: recipient, ccs: cc_recipients
  )
end

When(/^Nathalie submits an erroneous letter$/) do
  create_simple_letter(patient: @patty, user: @nathalie, issued_on: nil,
    recipient: @patty
  )
end


Then(/^Patty has a new letter for "(.*?)"$/) do |recipient|
  map = {
    "herself" => @patty,
    "her doctor" => @patty.doctor,
    "John Doe in London" => { name: "John Doe", city: "London" }
  }

  expect_simple_letter_to_exist(@patty, recipient: map[recipient])
end

Then(/^Nathalie can update Patty's letter$/) do
  update_simple_letter(patient: @patty, user: @nathalie)
end

Then(/^the letter is not accepted$/) do
  expect_simple_letter_to_be_refused
end

Then(/^Patty's letter has "(.*?)" in CC$/) do |ccs|
  cc_recipients = ccs.split(",").map do |cc|
    case cc
    when "herself"
      @patty
    when "her doctor"
      @patty.doctor
    when "John Doe in London"
      { name: "John Doe", city: "London" }
    end
  end
  expect_simple_letter_to_have_ccs(@patty, ccs: cc_recipients)
end
