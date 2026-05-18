# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Creating a HEROIC Clinic Visit", :js do
  include SlimSelectHelper

  context "with valid inputs" do
    it "creates the visit" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      create(:heroic_clinic)
      create(:clinic, name: "Other Clinic")

      visit new_patient_clinic_visit_path(patient)

      slim_select "HEROIC", from: "Clinic"

      # This will cause the page to refresh, loading in HEROIC fields.

      fill_in "Date", with: "12-Feb-2018"
      fill_in "Height", with: "1.25"
      fill_in "Weight", with: "30.2"
      fill_in "Pulse", with: "78"

      select "Small", from: "Cuff size"
      select "Once a week", from: "Physical activity"

      find(:css, ".clinic_visit_document_blood_pressure1_systolic input").set("140")
      find(:css, ".clinic_visit_document_blood_pressure1_diastolic input").set("90")
      find(:css, ".clinic_visit_document_blood_pressure2_systolic input").set("141")
      find(:css, ".clinic_visit_document_blood_pressure2_diastolic input").set("91")
      find(:css, ".clinic_visit_document_blood_pressure3_systolic input").set("142")
      find(:css, ".clinic_visit_document_blood_pressure3_diastolic input").set("92")

      within "article.smoking" do
        select "Refused", from: "History"
        fill_in "Number", with: 51
        select "Refused", from: "Ecigarettes"
      end

      within "article.alcohol" do
        select "Refused", from: "History"
        fill_in "Units", with: "14"
      end

      within "article.urinalysis" do
        select "Trace", from: "Urine Protein"
        select "Trace", from: "Urine Blood"
        select "Negative", from: "Glucose"
        select "Negative", from: "Nitrate"
        select "Trace", from: "Leucocytes"
        select "1.005", from: "Specific gravity"
      end

      within "article.health_status" do
        select "I have no problems in walking about", from: "Mobility"
        select "I have slight problems washing or dressing myself", from: "Self care"
        select "I have moderate problems doing my usual activities", from: "Usual activities"
        select "I have severe pain or discomfort", from: "Pain"
        select "I am extremely anxious or depressed", from: "Anxiety"
        fill_in "How good or bad your health is TODAY", with: "71"
      end

      click_on "Save"

      expect(page).to have_current_path(patient_clinic_visits_path(patient))

      visit = Renalware::Clinics.cast_patient(patient.reload).clinic_visits.last
      expect(visit).to be_present
      expect(visit.diastolic_bp).to eq(90)
      expect(visit.systolic_bp).to eq(140)

      document = visit.document
      smoking = document.smoking
      expect(smoking.history).to eq("99_refused")
      expect(smoking.number).to eq(51)
      expect(smoking.ecigarettes).to eq("99_refused")

      alcohol = document.alcohol
      expect(alcohol.history).to eq("99_refused")
      expect(alcohol.units).to eq(14)

      urinalysis = document.urinalysis
      expect(urinalysis.glucose).to eq("1_negative")
      expect(urinalysis.nitrate).to eq("1_negative")
      expect(urinalysis.leucocytes).to eq("2_trace")
      expect(urinalysis.specific_gravity).to eq("2_1-005")
      expect(visit.urine_protein).to eq("trace")
      expect(visit.urine_blood).to eq("trace")

      health_status = document.health_status
      expect(health_status.mobility).to eq("1_none")
      expect(health_status.self_care).to eq("2_slight")
      expect(health_status.usual_activities).to eq("3_moderate")
      expect(health_status.pain).to eq("4_severe")
      expect(health_status.anxiety).to eq("5_extreme")
      expect(health_status.health_today_out_of_100).to eq(71)
    end
  end
end
