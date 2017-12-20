# rubocop:disable Metrics/ModuleLength
require "rails_helper"
module Renalware
  RSpec.describe "Admission Inpatient management", type: :request do
    let(:user) { @current_user }
    let(:time) { Time.zone.now }
    let(:hospital_unit) { create(:hospital_unit, unit_code: "HospUnit1") }
    let(:hospital_ward) { create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit) }

    def convert_hash_dates_to_string_using_locale(hash)
      hash.each { |key, val| hash[key] = I18n.l(val) if val.is_a?(Date) }
    end

    def create_inpatient
      create(:admissions_inpatient,
             by: user,
             patient: create(:patient, by: user),
             admitted_on: Time.zone.today,
             admission_type: :unknown,
             reason_for_admission: "Reason",
             hospital_unit: hospital_unit,
             hospital_ward: hospital_ward)
    end

    describe "GET index", type: :feature do
      it "lists inpatients" do
        consult = create_inpatient
        login_as_clinical
        visit admissions_inpatients_path

        expect(page).to have_http_status(:success)

        within(".non-patient-page") do
          expect(body).to have_content("Admission Inpatients")
          expect(body).to have_content("HospUnit1")
          expect(body).to have_content(consult.patient.to_s)
        end
      end
    end

    describe "GET new" do
      it "render the form" do
        get new_admissions_inpatient_path

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new, format: :html)
      end
    end

    describe "POST JS create" do
      context "with valid inputs" do
        it "creates the inpatient" do
          patient = create(:patient, by: user)
          create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit)

          params = {
            patient_id: patient.id,
            hospital_unit_id: hospital_unit.id,
            hospital_ward_id: hospital_unit.wards.first.id,
            admitted_on: "12-Dec-2017",
            admission_type: "unknown",
            reason_for_admission: "reason",
            consultant: "Mr X",
            discharge_destination: "home",
            discharge_summary: "summary",
            transferred_on: "11-Dec-2017",
            discharged_on: "10-Dec-2017",
            notes: "Notes",
            summarised_by_id: user.id
          }

          post admissions_inpatients_path, params: { admissions_inpatient: params }

          follow_redirect!
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)

          inpatients = Renalware::Admissions::Inpatient.all
          expect(inpatients.length).to eq(1)
          inpatient = inpatients.first

          # Do a direct diff on supplied params and the saved object's attributes, excluding
          # attributes that we don't care about.
          attribs = inpatient.attributes.symbolize_keys.except(
            :id,
            :updated_at,
            :created_at,
            :created_by_id,
            :updated_by_id,
            :deleted_at
          )
          convert_hash_dates_to_string_using_locale(attribs)

          expect(inpatient.discharge_destination).to eq("home")
          expect(inpatient.consultant).to eq("Mr X")
          expect(inpatient.reason_for_admission).to eq("reason")
          expect(inpatient.hospital_unit_id).to eq(hospital_unit.id)
          expect(inpatient.hospital_ward_id).to eq(hospital_ward.id)
          expect(inpatient.admitted_on).to eq(Time.zone.parse("12-Dec-2017"))
          expect(inpatient.transferred_on).to eq(Time.zone.parse("11-Dec-2017"))
          expect(inpatient.discharged_on).to eq(Time.zone.parse("10-Dec-2017"))
          expect(inpatient.notes).to eq("Notes")
          expect(inpatient.discharge_summary).to eq("summary")
          expect(inpatient.summarised_by_id).to eq(user.id)
        end
      end

      context "with invalid inputs" do
        it "re-renders the modal form with validation errors" do
          params = { patient_id: nil }

          post admissions_inpatients_path, params: { admissions_inpatient: params }

          expect(response).to have_http_status(:success)
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET html edit" do
      it "renders the form" do
        get edit_admissions_inpatient_path(create_inpatient)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH html update" do
      context "with valid inputs" do
        it "updates the consult" do
          inpatient = create_inpatient
          hospital_unit2 = create(:hospital_unit, unit_code: "HospUnit2")

          params = { hospital_unit_id: hospital_unit2.id }

          patch(admissions_inpatient_path(inpatient), params: { admissions_inpatient: params })

          follow_redirect!
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
          expect(inpatient.reload.hospital_unit_id).to eq(hospital_unit2.id)
        end
      end

      context "with invalid inputs" do
        it "re-renders the modal form with validation errors" do
          inpatient = create_inpatient
          params = { hospital_unit_id: nil }

          patch(admissions_inpatient_path(inpatient), params: { admissions_inpatient: params })

          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "DELETE html destroy" do
      it "soft deletes the consult and sets the ended_on date to today" do
        inpatient = create_inpatient

        expect{
          delete admissions_inpatient_path(inpatient)
        }
        .to change{ Admissions::Inpatient.count }.by(-1)
        .and change{ Admissions::Inpatient.deleted.count }.by(1)
      end
    end
  end
end
