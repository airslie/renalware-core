# frozen_string_literal: true

require "rails_helper"

# When adding an HD session, if there are any drugs to be given
# then these can be marked as administered and the nurse and a witness must
# sign then for them to be valid.

describe "Administering drugs while creating an HD Session", type: :system do
  let(:patient) { create(:hd_patient) }

  context "when the patient has no drugs to be given on HD" do
    it "the HD Drugs section is empty on the HD form" do
      create(:prescription, patient: patient, administer_on_hd: false)
      login_as_clinical

      visit renalware.new_patient_hd_session_path(patient)

      within ".hd-drug-administrations" do
        expect(page).to have_css(".hd-drug-administration", count: 0)
      end
    end
  end

  context "when the patient drugs to be given on HD", js: false do
    it "the HD Drugs section lists these" do
      create(:prescription, patient: patient, administer_on_hd: true)
      create(:prescription, patient: patient, administer_on_hd: true)
      login_as_clinical

      visit renalware.new_patient_hd_session_path(patient)

      within ".hd-drug-administrations" do
        expect(page).to have_css(".hd-drug-administration", count: 2)
      end
    end
  end

  describe "Marking an HD drug as administered", js: true do
    context "when checking Administered on an HD Drug" do
      it "changes the class to indicate it requires authorisation" do
        create(:prescription, patient: patient, administer_on_hd: true)
        login_as_clinical

        visit renalware.new_patient_hd_session_path(patient)

        within(".hd-drug-administration .hd-drug-administered") { choose "Yes" }
        expect(page).to have_css(".hd-drug-administration.administered", count: 1)

        within(".hd-drug-administration") { choose "No" }
        expect(page).to have_css(".hd-drug-administration.administered", count: 0)
      end
    end
  end

  describe "default nurse" do
    context "when displaying an HD form containing HD drugs" do
      it "defaults the Nurse to the currently logged-in user" do
        create(:prescription, patient: patient, administer_on_hd: true)
        user = login_as_clinical

        visit renalware.new_patient_hd_session_path(patient)

        within(".hd-drug-administration") do
          expect(page).to have_css(
            ".user-and-password--administrator " \
            "select option[selected='selected'][value='#{user.id}']",
            count: 1
          )
        end
      end
    end
  end
end
