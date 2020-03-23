# frozen_string_literal: true

require "rails_helper"

describe "Sending a private message", type: :system do
  include AjaxHelpers

  it "A clinician sends a private message about a patient", js: true do
    user = login_as_clinical
    patient = create(:messaging_patient, by: user)
    create(:internal_recipient, family_name: "X", given_name: "Y")

    visit patient_path(patient)
    click_on "Send message"
    expect(page).to have_css("#new_internal_message")

    fill_in "Body", with: "Test"

    # Problem here: select2 not initialised at this point.
    select2 "X, Y", from: "Recipients"
    click_on "Send"

    expect(page).to have_no_css("#new_internal_message")

    expect(patient.messages.first).to have_attributes(
      body: "Test"
    )
  end

  # scenario "A clinician replies to a message", js: true do
  #   user = login_as_clinical
  #   patient = create(:messaging_patient, created_by: user, updated_by: user)
  #   recipient = create(:messaging_recipient, family_name: "X", given_name: "Y")
  #   receipt = build(:receipt, recipient: recipient, message: )
  #   create(:internal_message, receipts: [receipt], author: user)

  #   visit patient_path(patient)

  #   click_on "Send message"

  #   fill_in "Body", with: "Test"
  #   select2 "X, Y", from: "#message_recipient_ids"
  #   click_on "Send"

  #   expect(page).to have_content("Message was successfully sent")
  # end
end
