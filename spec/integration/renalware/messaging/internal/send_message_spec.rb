require "rails_helper"

feature "Sending a private message" do

  scenario "A clinician sends a private message about a patient", js: true do
    user = login_as_clinician
    patient = create(:messaging_patient, by: user)
    create(:internal_recipient, family_name: "X", given_name: "Y")

    visit patient_path(patient)

    click_on "Send message"

    fill_in "Body", with: "Test"
    select2 "X, Y", from: "#message_recipient_ids"
    click_on "Send"

    expect(page).to have_content("Message was successfully sent")
  end

  # scenario "A clinician replies to a message", js: true do
  #   user = login_as_clinician
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
