require "rails_helper"

RSpec.describe "Admission Consult management", type: :request do
  let(:user) { @current_user }
  let(:time) { Time.zone.now }
  let(:hospital_unit) { create(:hospital_unit, unit_code: "HospUnit1") }

  def create_consult
    create(:admissions_consult,
           by: user,
           patient: create(:patient, by: user),
           hospital_unit: hospital_unit)
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
        params = {
          patient_id: patient.id,
          hospital_unit_id: hospital_unit.id
        }

        post admissions_consults_path, params: { admissions_consult: params }

        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)

        consults = Renalware::Admissions::Consult.all
        expect(consults.length).to eq(1)
        expect(consults.first.hospital_unit_id).to eq(hospital_unit.id)
        expect(consults.first.patient_id).to eq(patient.id)
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
end
