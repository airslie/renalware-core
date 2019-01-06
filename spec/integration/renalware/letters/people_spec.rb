# frozen_string_literal: true

require "rails_helper"
require "test_support/autocomplete_helpers"
require "test_support/ajax_helpers"

describe "Add person to directory and assign as a contact for a patient",
               type: :system,
               js: true do

  include AutocompleteHelpers
  include AjaxHelpers

  before do
    @user = login_as_clinical
  end

  let(:patient) { create(:patient, by: @user) }
  let(:person) { build(:directory_person, by: @user, address: build(:address)) }

  describe "creating a person and assign as a contact" do
    context "with valid attributes" do
      it "responds successfully" do
        contact_description = create(:letter_contact_description)

        visit patient_letters_contacts_path(patient)

        try_create_contact_with_valid_params(contact_description)

        expect_new_contact_for_patient
      end
    end

    context "with invalid attributes" do
      it "responds with errors" do
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_invalid_params

        expect_to_display_errors
      end
    end

    # rubocop:disable Metrics/AbcSize
    def try_create_contact_with_valid_params(contact_description)
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
      # rubocop:enable Metrics/AbcSize

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
