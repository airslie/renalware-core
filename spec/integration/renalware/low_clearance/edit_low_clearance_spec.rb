require "rails_helper"

feature "Edit Low Clearance" do
  include PatientsSpecHelper

  let(:user) { @current_user }
  let(:patient) do
    create(:low_clearance_patient).tap do |pat|
      set_modality(
        patient: pat,
        modality_description: create(:low_clearance_modality_description),
        by: user
      )
    end
  end

  describe "edit low clearance data for a patient" do
    context "with valid attributes" do
      it "yasy" do
        login_as_clinical
        visit patient_path(patient)
        within ".side-nav" do
          click_on "Low Clearance"
        end

        within ".page-heading" do
          expect(page).to have_content("Low Clearance")
        end

        within ".page-actions" do
          click_on "Add"
          click_on "Profile"
        end

        fake_date_string = "12-Dec-2017"
        fake_date = Date.parse(fake_date_string)
        fill_in "Date first seen", with: fake_date_string
        select "CAPD LA", from: "Dialysis plan"
        fill_in "Dialysis plan date", with: fake_date_string
        fill_in "Predicted ESRF date", with: fake_date_string
        fill_in "Referral CRE", with: "123"
        fill_in "Referral eGFR", with: "234"
        fill_in "Referred by", with: "Xx"
        select "Invited", from: "Education status"
        select "Day", from: "Education type"
        fill_in "Date attended educ.", with: fake_date_string

        # fill_in low_clearance_t("first_seen_on"), with: fake_date
        # select "CAPD LA", from: low_clearance_t("dialysis_plan")
        # fill_in low_clearance_t("dialysis_planned_on"), with: fake_date
        # fill_in low_clearance_t("predicted_esrf_date"), with: fake_date
        # fill_in low_clearance_t("referral_creatinine"), with: "123"
        # fill_in low_clearance_t("referral_egfr"), with: "456"
        # fill_in low_clearance_t("referred_by"), with: "A User"
        # select "Attended", from: low_clearance_t("education_status")
        # select "Day", from: low_clearance_t("education_type")
        # fill_in low_clearance_t("attended_on"), with: fake_date
        # find("div.radio_buttons", text: low_clearance_t("dvd1_provided")).choose("Yes")
        # find("div.radio_buttons", text: low_clearance_t("dvd2_provided")).choose("No")
        # find("div.radio_buttons", text: low_clearance_t("transplant_referral")).choose("Yes")
        # fill_in low_clearance_t("transplant_referred_on"), with: fake_date
        # find("div.radio_buttons", text: low_clearance_t("home_hd_possible")).choose("Yes")
        # find("div.radio_buttons", text: low_clearance_t("self_care_possible")).choose("Yes")
        # fill_in low_clearance_t("access_notes"), with: "Notes"

        within ".form-actions" do
          click_on "Save"
        end

        expect(page.current_path).to eq(patient_low_clearance_dashboard_path(patient))

        profile_document = Renalware::LowClearance.cast_patient(patient).profile.document
        expect(profile_document.first_seen_on).to eq(fake_date)
        expect(profile_document.dialysis_plan).to eq("capd_la")
        expect(profile_document.dialysis_planned_on).to eq(fake_date)
        expect(profile_document.predicted_esrf_date).to eq(fake_date)
        expect(profile_document.referral_creatinine).to eq(123)
        expect(profile_document.referral_egfr).to eq(234.0)
        expect(profile_document.education_status).to eq("invited")
        expect(profile_document.education_type).to eq("day")
        # expect(profile_document.referred_by).to eq("A User")

        # expect(profile_document.dvd1_provided).to eq("yes")
        # expect(profile_document.dvd2_provided).to eq("no")
        # expect(profile_document.transplant_referral).to eq("yes")
        # expect(profile_document.transplant_referred_on).to eq(fake_date)
        # expect(profile_document.home_hd_possible).to eq("yes")
        # expect(profile_document.self_care_possible).to eq("yes")
        # expect(profile_document.access_notes).to eq("Notes")
      end
    end
  end
end
