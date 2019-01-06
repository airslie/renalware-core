# frozen_string_literal: true

require "rails_helper"
require "test_support/autocomplete_helpers"
require "test_support/ajax_helpers"

describe "Assign electronic CCs" do
  include AutocompleteHelpers
  include AjaxHelpers

  let(:practice) { create(:practice) }
  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:patient) do
    create(
      :letter_patient,
      primary_care_physician: primary_care_physician,
      practice: practice
    )
  end

  describe "assigning a new person as a CC recipient", js: true, type: :system do
    before do
      create(:letter_letterhead)
    end

    context "with valid attributes" do
      it "responds successfully" do
        user = login_as_clinical

        visit patient_letters_letters_path(patient)
        click_on "Create"
        click_on "Simple Letter"

        fill_out_letter

        # Add ourself as an Electronic CC.
        select2 user.given_name, css: "article.electonic_ccs"

        within ".top" do
          click_on "Create"
        end

        letter = patient.letters.last

        expect(letter.electronic_cc_recipients).to eq([user])
      end
    end

    def fill_out_letter
      fill_in "Date", with: I18n.l(Time.zone.today)
      select Renalware::Letters::Letterhead.first.name, from: "Letterhead"
      select Renalware::User.first.to_s, from: "Author"
      fill_in "Description", with: "::description::"
      choose("Primary Care Physician")
      wait_for_ajax
    end
  end
end
