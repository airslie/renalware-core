require "rails_helper"
require "test_support/autocomplete_helpers"
require "test_support/ajax_helpers"

RSpec.describe "Manage electronic CCs", type: :feature do
  include LettersSpecHelper
  include AutocompleteHelpers
  include AjaxHelpers

  before(:all) do
    @primary_care_physician = create(:letter_primary_care_physician)
    @patient = create(:letter_patient, primary_care_physician: @primary_care_physician)
  end

  after(:all) do
    @patient.destroy!
    @primary_care_physician.destroy!
  end

  scenario "Marks an Electronic CC as `read` for an approved letter", js: true do
    user = login_as_clinician

    approved_letter = create_letter(
      to: :patient,
      state: :approved,
      patient: @patient,
      description: "xxx"
    )
    create(:letter_electronic_receipt, letter: approved_letter, recipient: user)

    draft_letter = create_letter(
      to: :patient,
      state: :draft,
      patient: @patient,
      description: "yyy"
    )
    create(:letter_electronic_receipt, letter: draft_letter, recipient: user)

    visit dashboard_path

    within ".electronic-ccs" do
      expect(page).to have_content(approved_letter.description)
      expect(page).not_to have_content(draft_letter.description)
      expect(page).to have_css("tbody tr", count: 1)

      click_on "Toggle"
      click_on "Mark as read"

      expect(page).not_to have_content(approved_letter.description)
    end
  end
end
