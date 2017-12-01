require "rails_helper"
require "test_support/autocomplete_helpers"
require "test_support/ajax_helpers"

RSpec.describe "Assign a contact to a patient", type: :feature, js: true do
  include AutocompleteHelpers
  include AjaxHelpers

  before do
    @user = login_as_read_write
  end

  let(:patient) { create(:patient, by: @user) }
  let!(:person) { create(:directory_person, by: @user) }
  let!(:contact_description) { create(:letter_contact_description) }

  describe "creating a contact" do
    context "given valid attributes" do
      it "responds successfully" do
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_valid_params

        expect_new_contact_for_patient
      end
    end

    context "given valid attributes" do
      it "responds with errors" do
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_invalid_params

        expect_to_display_errors
      end
    end

    def try_create_contact_with_valid_params
      click_on "Add"

      within("#add-patient-contact-modal") do
        fill_autocomplete "#add-patient-contact-modal", "person_auto_complete",
          with: person.family_name, select: person.to_s
        select contact_description.to_s, from: "Description"

        click_on "Save"
      end

      wait_for_ajax
    end

    def try_create_contact_with_invalid_params
      click_on "Add"

      within("#add-patient-contact-modal") do
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
