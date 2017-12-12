require "rails_helper"
require "test_support/autocomplete_helpers"
require "test_support/ajax_helpers"

RSpec.describe "Add person to directory and assign as a contact for a patient",
               type: :feature,
               js: true do

  include AutocompleteHelpers
  include AjaxHelpers

  before do
    @user = login_as_clinical
  end

  let!(:contact_description) { create(:letter_contact_description) }
  let(:patient) { create(:patient, by: @user) }
  let(:person) { build(:directory_person, by: @user, address: build(:address)) }

  describe "creating a person and assign as a contact" do
    context "given valid attributes" do
      it "responds successfully" do
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_valid_params

        expect_new_contact_for_patient
      end
    end

    context "given invalid attributes" do
      it "responds with errors" do
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_invalid_params

        expect_to_display_errors
      end
    end

    def try_create_contact_with_valid_params
      click_on "Add"

      within("#add-patient-contact-modal") do
        click_on "Person not found in directory"
        wait_for_ajax

        fill_in "Family Name", with: person.family_name
        fill_in "Given Name", with: person.given_name
        fill_in "Line 1", with: person.address.street_1
        select contact_description.name, from: "Description"
        fill_in "Notes", with: "some contact notes"

        click_on "Save"
      end

      wait_for_ajax
    end

    def try_create_contact_with_invalid_params
      click_on "Add"

      within("#add-patient-contact-modal") do
        click_on "Person not found in directory"
        wait_for_ajax

        click_on "Save"
      end

      wait_for_ajax
    end

    def expect_new_contact_for_patient
      expect(page).to have_css("#contacts tbody tr", count: 1)
    end

    def expect_to_display_errors
      expect(page).to have_css(".error-messages")
    end
  end
end
