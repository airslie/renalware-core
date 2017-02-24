require "rails_helper"
require "test_support/autocomplete_helpers"
require "test_support/ajax_helpers"

RSpec.describe "Assign a person as a CC recipient", type: :feature do
  include AutocompleteHelpers
  include AjaxHelpers

  before do
    login_as_clinician
  end

  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:patient) { create(:letter_patient, primary_care_physician: primary_care_physician) }
  let(:address) { build(:address, name: "::cc_name::") }
  let!(:person) { create(:directory_person, address: address, by: create(:user)) }
  let(:user) { create(:user) }
  let!(:contact_description) { create(:letter_contact_description) }

  describe "assigning a new person as a CC recipient", js: true do
    before do
      create(:letter_letterhead)
      create(:letter_contact, patient: patient, person: create(:directory_person, by: user))
    end

    context "given valid attributes" do
      it "responds successfully" do
        visit patient_letters_letters_path(patient)
        click_on "Create"
        click_on "Simple Letter"

        fill_out_letter

        try_adding_person_as_cc_recipient

        within ".top" do
          click_on "Create"
        end

        letter = patient.letters.last

        # Use the formatted route, otherwise we cannot check content in the iframe
        # of the regular show page.
        visit patient_letters_letter_formatted_path(patient, letter)

        expect_letter_with_person_as_cc_recipient
      end
    end

    def try_adding_person_as_cc_recipient
      click_on "Add new person to the list"

      within("#add-patient-contact-as-cc-modal") do
        fill_autocomplete "#add-patient-contact-as-cc-modal", "person_auto_complete",
          with: person.family_name, select: person.to_s
        select contact_description.name, from: "Description"
        fill_in "Notes", with: "some contact notes"
        click_on "Save"
      end

      wait_for_ajax

      expect(page).to_not have_text("is already a contact for the patient")
    end

    def fill_out_letter
      fill_in "Date", with: I18n.l(Time.zone.today)
      select Renalware::Letters::Letterhead.first.name, from: "Letterhead"
      select Renalware::User.first.to_s, from: "Author"
      fill_in "Description", with: "::description::"
      choose("Primary Care Physician")
      wait_for_ajax
    end

    def expect_letter_with_person_as_cc_recipient
      expect(page).to have_text(address.name)
    end
  end
end
