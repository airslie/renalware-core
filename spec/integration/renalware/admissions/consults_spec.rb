# rubocop:disable Metrics/ModuleLength
require "rails_helper"
module Renalware
  RSpec.describe "Admission Consult management", type: :request do
    let(:user) { @current_user }
    let(:time) { Time.zone.now }
    let(:hospital_unit) { create(:hospital_unit, unit_code: "HospUnit1") }
    let(:hospital_ward) { create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit) }

    def convert_hash_dates_to_string_using_locale(hash)
      hash.each { |key, val| hash[key] = I18n.l(val) if val.is_a?(Date) }
    end

    def create_consult
      create(:admissions_consult,
             by: user,
             patient: create(:patient, by: user),
             started_on: Time.zone.today,
             hospital_unit: hospital_unit,
             hospital_ward: hospital_ward,
             consult_type: "TBC",
             description: "Lorem ipsum dolor")
    end

    describe "GET index" do
      it "lists consults" do
        consult = create_consult

        get admissions_consults_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Admission Consults")
        expect(response.body).to include("HospUnit1")
        expect(response.body).to include(consult.patient.to_s)
      end
    end

    describe "GET new" do
      it "renders a modal to allow a patient to be selected" do
        get new_admissions_consult_path

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new, format: :html)
      end
    end

    describe "POST JS create" do
      context "with valid inputs" do
        it "creates the consult" do
          patient = create(:patient, by: user)
          create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit)
          date = I18n.l(Time.zone.today)

          params = {
            patient_id: patient.id,
            hospital_unit_id: hospital_unit.id,
            hospital_ward_id: hospital_unit.wards.first.id,
            started_on: date,
            decided_on: date,
            transferred_on: date,
            consult_type: "TBC",
            transfer_priority: Renalware::Admissions::Consult.transfer_priority.values.first,
            aki_risk: Renalware::Admissions::Consult.aki_risk.values.first,
            seen_by_id: user.id,
            contact_number: "x123",
            requires_aki_nurse: true,
            description: "Lorem ipsum dolor sit amet"
          }

          post admissions_consults_path, params: { admissions_consult: params }

          follow_redirect!
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)

          consults = Renalware::Admissions::Consult.all
          expect(consults.length).to eq(1)
          consult = consults.first

          # Do a direct diff on supplied params and the saved object's attributes, excluding
          # attributes that we don't care about.
          attribs = consult.attributes.symbolize_keys.except(
            :id, :updated_at, :created_at, :created_by_id, :updated_by_id, :deleted_at, :ended_on
          )
          convert_hash_dates_to_string_using_locale(attribs)
          expect(HashDiff.diff(params, attribs)).to eq([])
        end
      end

      context "with invalid inputs" do
        it "re-renders the modal form with validation errors" do
          params = { patient_id: nil }

          post admissions_consults_path, params: { admissions_consult: params }

          expect(response).to have_http_status(:success)
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET html edit" do
      it "renders the form" do
        get edit_admissions_consult_path(create_consult)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH html update" do
      context "with valid inputs" do
        it "updates the consult" do
          consult = create_consult
          hospital_unit2 = create(:hospital_unit, unit_code: "HospUnit2")

          params = { hospital_unit_id: hospital_unit2.id }

          patch(admissions_consult_path(consult),
                params: { admissions_consult: params })

          follow_redirect!
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
          expect(consult.reload.hospital_unit_id).to eq(hospital_unit2.id)
        end
      end

      context "with invalid inputs" do
        it "re-renders the modal form with validation errors" do
          consult = create_consult
          params = { hospital_unit_id: nil }

          patch(admissions_consult_path(consult),
                params: { admissions_consult: params })

          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "DELETE html destroy" do
      it "soft deletes the consult and sets the ended_on date to today" do
        consult = create_consult

        expect{
          delete admissions_consult_path(consult)
        }
        .to change{ Admissions::Consult.count }.by(-1)
        .and change{ Admissions::Consult.deleted.count }.by(1)
      end
    end
  end
end
