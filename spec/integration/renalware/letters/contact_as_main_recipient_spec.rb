# frozen_string_literal: true

require "rails_helper"

describe "Assign a person as a main recipient", type: :system do
  include AjaxHelpers

  before do
    login_as_clinical
  end

  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:patient) { create(:letter_patient, primary_care_physician: primary_care_physician) }
  let(:address) { build(:address) }
  let!(:person) { create(:directory_person, address: address, by: create(:user)) }
  let(:user) { create(:user) }
  let!(:contact_description) { create(:letter_contact_description) }

  describe "assigning a new person as a main recipient", js: true do
    before do
      create(:letter_letterhead)
      create(:letter_contact, patient: patient, person: create(:directory_person, by: user))
      create(:letter_topic, text: "::description::")
    end

    context "with valid attributes" do
      it "responds successfully" do
        visit patient_letters_letters_path(patient)
        click_on t("btn.create_")
        click_on "Simple Letter"

        fill_out_letter

        try_adding_person_as_main_recipient

        select person.to_s, from: "letter_main_recipient_attributes_addressee_id"

        within ".top" do
          click_on t("btn.create")
        end

        visit patient_letters_letters_path(patient)

        expect_letter_with_person_as_main_recipient
      end
    end

    def try_adding_person_as_main_recipient
      click_on "Add a different recipient via the contacts Directory"

      within("#add-patient-contact-modal") do
        select2(
          person.family_name,
          css: "#person-id-select2",
          search: true
        )
        select contact_description.name, from: "Description"

        click_on t("btn.save")
      end

      wait_for_ajax

      expect(page).to have_no_text("is already a contact for the patient")
    end

    def fill_out_letter
      within "#letter-form" do
        select2 "::description::", css: ".letter_topic"
        select Renalware::Letters::Letterhead.first.name, from: "Letterhead"
        select Renalware::User.first.to_s, from: "Author"
        choose("Patient's Contact")
      end
      wait_for_ajax
    end

    def expect_letter_with_person_as_main_recipient
      expect(page).to have_text(address.to_s)
    end
  end
end
