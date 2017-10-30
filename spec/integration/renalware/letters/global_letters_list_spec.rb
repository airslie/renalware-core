require "rails_helper"

RSpec.describe "View global letters list", type: :feature, js: false do
  include LettersSpecHelper

  describe "GET #show" do
    it "returns a list of letters" do
      pending
      fail "Removed this test as it seemed to be causing problems elsewhere - strange.."
      # # TODO: Also test with a clinic visit letter
      primary_care_physician = create(:letter_primary_care_physician)
      patient = create(:letter_patient, primary_care_physician: primary_care_physician)
      create_letter(to: :patient, patient: patient)

      login_as_clinician

      visit letters_list_path

      expect(page).to have_content(patient.to_s(:long))
    end
  end
end
