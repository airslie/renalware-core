# frozen_string_literal: true

require "rails_helper"

feature "Managing an existing letter contact" do
  include AjaxHelpers

  context "with valid parameters" do
    scenario "A user changes an existing patient's contact to for example remove their default cc "\
             "or change their description", js: true do
      user = @current_user
      patient = create(:letter_patient)
      description1 = create(:letter_contact_description, name: "Parent")
      description2 = create(:letter_contact_description, name: "Child")
      person = create(:directory_person, by: user)
      contact = create(
        :letter_contact,
        patient: patient,
        description: description1,
        person: person,
        default_cc: true
      )

      login_as_clinical
      visit patient_letters_contacts_path(patient)

      within "#letters_contact_#{contact.id}" do
        expect(page).to have_content("Yes")
        expect(page).to have_content("Parent")
        click_on "Edit"
      end

      expect(page).to have_content("Edit Patient Contact")

      within ".letters_contact_default_cc" do
        choose "No"
      end

      select description2.name, from: "Description"

      click_on "Save"

      wait_for_ajax

      contact.reload

      expect(contact.patient_id).to eq(patient.id)
      expect(contact.person_id).to eq(person.id)
      expect(contact.default_cc).to be_falsey
      expect(contact.description_id).to eq(description2.id)

      within "#letters_contact_#{contact.id}" do
        expect(page).to have_content("No")
        expect(page).to have_content("Child")
      end

      expect(page).to have_css(".flash-message .alert-box.success")
    end
  end

  context "with invalid parameters" do
    scenario "A user cannot change an existing patient contact", js: true do
      user = @current_user
      patient = create(:letter_patient)
      create(
        :letter_contact,
        patient: patient,
        person: create(:directory_person, by: user),
        default_cc: true
      )

      login_as_clinical
      visit patient_letters_contacts_path(patient)

      within "#contacts table tbody tr:first-child" do
        click_on "Edit"
      end

      # Specify neither a description or other description
      select "", from: "Description"
      fill_in "", with: "Other description"

      click_on "Save"

      expect(page).to have_css(".modal__body .error-messages")
    end
  end
end
