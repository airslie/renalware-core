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

        fill_in "Date first seen", with: "13-Dec-2017"
        select "CAPD LA", from: "Dialysis plan"
        fill_in "Dialysis plan date", with: "13-Dec-2017"
        fill_in "Predicted ESRF date", with: "13-Dec-2017"
        fill_in "Referral CRE", with: "123"
        fill_in "Referral eGFR", with: "234"
        fill_in "Referred by", with: "Xx"
        select "Invited", from: "Education status"
        select "Day", from: "Education type"
        fill_in "Date attended educ.", with: "13-Dec-2017"

        within ".form-actions" do
          click_on "Save"
        end

        expect(page.current_path).to eq(patient_low_clearance_dashboard_path(patient))
      end
    end
  end
end
