# frozen_string_literal: true

require "rails_helper"

# When adding an HD session, if there are any drugs to be given
# then these can be marked as administered and the nurse and a witness must
# sign then for them to be valid.

# rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
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
      it "changes the classes on .hd-drug-administration to indicate the choice" do
        create(:prescription, patient: patient, administer_on_hd: true)
        login_as_clinical

        visit renalware.new_patient_hd_session_path(patient)

        expect(page).to have_css(".hd-drug-administration.undecided", count: 1)

        within(".hd-drug-administration .hd-drug-administered") { choose "Yes" }
        expect(page).to have_css(".hd-drug-administration.administered", count: 1)
        expect(page).to have_css(".hd-drug-administration.not-administered", count: 0)
        expect(page).to have_css(".hd-drug-administration.undecided", count: 0)

        within(".hd-drug-administration") { choose "No" }
        expect(page).to have_css(".hd-drug-administration.not-administered", count: 1)
        expect(page).to have_css(".hd-drug-administration.administered", count: 0)
        expect(page).to have_css(".hd-drug-administration.undecided", count: 0)
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

  describe "authorising and saving (but not signing-off) a prescription administration", js: true do
    context "when indicating the prescriptions was administered" do
      it "the happy path" do
        create(:prescription, patient: patient, administer_on_hd: true)
        unit = create(:hospital_unit, name: "X", unit_code: "Y", is_hd_site: true)
        password = "renalware"
        login_as_clinical
        nurse = create(:user, password: password)
        witness = create(:user, password: password)

        visit renalware.new_patient_hd_session_path(patient)

        select unit.to_s, from: "Hospital Unit"

        # There will be one .hd-drug-administration div. Select Administered: Yes
        within ".hd-drug-administration" do
          within(".hd-drug-administered") { choose "Yes" }
          fill_in "Notes", with: "Notes test"
        end

        # Fill in user and password fields
        # Note nurse == administrator here
        within ".user-and-password--administrator" do
          select2 nurse.given_name, from: "Nurse"
          fill_in "Password", with: "wrong_password"
          # Simulate a tab which will cause a blur and the handler will authenticate the password
          page.find(".user-password").send_keys :tab
          # we should now have a validation error as the password is invalid
          expect(page).to have_css(".invalid-password", visible: true)
          # Now enter the right password
          fill_in "Password", with: password
          page.find(".user-password").send_keys :tab
          expect(page).not_to have_css(".invalid-password", visible: true)
        end

        within ".user-and-password--witness" do
          select2 witness.given_name, from: "Witness"
          fill_in "Password", with: "wrong_password"
          page.find(".user-password").send_keys :tab
          # we should now have a validation error as the password is invalid
          expect(page).to have_css(".invalid-password", visible: true)
          # Now enter the right password
          fill_in "Password", with: password
          page.find(".user-password").send_keys :tab
          expect(page).not_to have_css(".invalid-password", visible: true)
        end

        within page.first(".hd-session-form-actions") do
          click_on "Save"
        end

        expect(Renalware::HD::Session.count).to eq(1)

        session = Renalware::HD::Session.first
        expect(session.prescription_administrations.count).to eq(1)

        pa = session.prescription_administrations.first
        expect(pa.notes).to eq("Notes test")
        expect(pa.administered).to eq(true) # ie we clicked on Administered: Yes
        expect(pa.administered_by_id).to eq(nurse.id)
        expect(pa.witnessed_by_id).to eq(witness.id)
        expect(pa.administrator_authorised).to eq(true)
        expect(pa.witness_authorised).to eq(true)
      end
    end

    context "when indicating the drug was NOT administered" do
      it "happy path" do
        create(:prescription, patient: patient, administer_on_hd: true)
        reason = Renalware::HD::PrescriptionAdministrationReason.create(name: "The reason")
        unit = create(:hospital_unit, name: "X", unit_code: "Y", is_hd_site: true)
        login_as_clinical

        visit renalware.new_patient_hd_session_path(patient)

        select unit.to_s, from: "Hospital Unit"

        within ".hd-drug-administration" do
          within(".hd-drug-administered") { choose "No" }
          fill_in "Notes", with: "Notes test"
          select "The reason", from: "Reason"
        end

        within page.first(".hd-session-form-actions") do
          click_on "Save"
        end

        expect(Renalware::HD::Session.count).to eq(1)

        session = Renalware::HD::Session.first
        expect(session.prescription_administrations.count).to eq(1)

        pa = session.prescription_administrations.first
        expect(pa.notes).to eq("Notes test")
        expect(pa.reason).to eq(reason)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
