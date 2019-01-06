# frozen_string_literal: true

require "rails_helper"

describe "Edit Low Clearance", type: :system do
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
      it "saves" do
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

        within ".form-actions" do
          click_on "Save"
        end

        expect(page).to have_current_path(patient_low_clearance_dashboard_path(patient))

        profile_document = Renalware::LowClearance.cast_patient(patient).profile.document
        expect(profile_document).to have_attributes(
          first_seen_on: fake_date,
          dialysis_plan: "capd_la",
          dialysis_planned_on: fake_date,
          predicted_esrf_date: fake_date,
          referral_creatinine: 123,
          referral_egfr: 234.0,
          education_status: "invited",
          education_type: "day"
        )
      end
    end
  end
end
