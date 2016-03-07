require "rails_helper"

module Renalware
  feature "Drafting a letter", js: true do

    background do
      create(:letter_description, text: "Simple letter")
      @doctor = create(:doctor)
      @practice = create(:practice)
      @doctor.practices << @practice
      @patient = create(:patient, doctor: @doctor, practice: @practice)
      @letter = create(:letter, patient: @patient)

      login_as_clinician
      visit new_patient_letters_letter_path(patient_id: @patient.to_param)
    end

    scenario "a valid letter" do
      select "Simple letter", from: "Description"
      select2 "Aneurin Bevan", from: "#letter_author_id"
      fill_in "Body", with: "Dear Dr. Goode, I am pleased to inform you that things are going extremely well"

      click_on "Save"

      expect(current_path).to eq(patient_letters_letters_path(@patient))

      within("table.letters tbody tr:first-child") do
        expect(page).to have_content("Aneurin Bevan")
        expect(page).to have_content("Simple letter")
        expect(page).to have_content("draft")
      end
    end

    scenario "an invalid letter" do
      select2 "Aneurin Bevan", from: "#letter_author_id"

      click_on "Save"

      expect(page).to have_content("You have failed to add a new letter")
      expect(page).to have_content("Description can't be blank")
    end

    scenario "a letter to a recipient other than the doctor or patient" do
      select "Simple letter", from: "Description"
      select2 "Aneurin Bevan", from: "#letter_author_id"
      choose "letter_recipient_other"
      fill_in "other_recipient_address", with: "28 Newton Road, Torquay, Devon, TQ2 5BZ"
      fill_in "Body", with: "Dear Dr. Goode, I am pleased to inform you that the latest clinic appointment went extremely well"

      expect { click_on "Save" }.to change(Address, :count).by(1)

      expect(current_path).to eq(patient_letters_letters_path(@patient))
    end

    scenario "a letter sent for review" do
      select "Simple letter", from: "Description"
      select "review", from: "Status"
      select2 "Aneurin Bevan", from: "#letter_author_id"
      fill_in "Body", with: "Dear Dr. Goode, I am pleased to inform you that the latest clinic appointment went extremely well"

      click_on "Save"

      within("table.letters tbody tr:first-child") do
        expect(page).to have_content("review")
      end
    end

    scenario "edit a letter" do
      visit edit_patient_letters_letter_path(@patient, @letter)

      select "review", from: "Status"

      click_on "Update"

      within("table.letters tbody tr:first-child") do
        expect(page).to have_content("review")
      end
    end
  end
end
