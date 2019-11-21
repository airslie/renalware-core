# frozen_string_literal: true

require "rails_helper"
require "test_support/ajax_helpers"

# rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
describe "Remembering last used letter choices in the user's session", type: :system, js: true do
  it "once a letter is created, subsequent new letters remember letterhead, author, " \
     "date and description" do
    patient = create(
      :letter_patient,
      primary_care_physician: create(:letter_primary_care_physician),
      practice: create(:practice)
    )
    letterheads = [
      create(:letter_letterhead, name: "LetterHeadA"),
      create(:letter_letterhead, name: "LetterHeadB")
    ]
    descriptions = [
      create(:letter_description, text: "LetterDescriptionA"),
      create(:letter_description, text: "LetterDescriptionB")
    ]
    users = [
      login_as_clinical,
      create(:user, family_name: "Jones", given_name: "Jane")
    ]
    letter_date = 1.month.ago.to_date

    visit new_patient_letters_letter_path(patient)

    # Check the intial defaults - all to be blank (because its a new session) apart from author
    # which will default to current user
    expect(page.find("#letter_author_id option[selected='selected']").value)
      .to eq(users[0].id.to_s)
    expect(page.find("#letter_issued_on").value).to eq("")
    expect(page.find("#letter_letterhead_id").value).to eq("")
    expect(page).not_to have_selector :css, "#letter_description option[selected='selected']"

    # Now fill in some fields. These fields are in RememberedPreferences (saved to a cookie) so
    # should be remembered the next time we create a letter
    fill_in "Date", with: I18n.l(letter_date)
    select letterheads[1].name, from: "Letterhead"
    select users[1], from: "Author"
    select2 descriptions[1].text, css: ".letter_description"
    choose("Primary Care Physician")

    within ".top" do
      click_on "Create"
    end

    # Now create another letter to test it has remebered our previous choices
    visit new_patient_letters_letter_path(patient)

    expect(page.find("#letter_letterhead_id").value).to eq(letterheads[1].id.to_s)
    expect(page.find("#letter_description option[selected='selected']").value)
      .to eq(descriptions[1].text)
    expect(page.find("#letter_issued_on").value).to eq(I18n.l(letter_date))
    expect(page.find("#letter_author_id option[selected='selected']").value)
      .to eq(users[1].id.to_s)
  end
end
# rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
