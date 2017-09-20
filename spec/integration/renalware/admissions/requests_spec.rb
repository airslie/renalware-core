require "rails_helper"

RSpec.describe "Admission Request (TCI) management", type: :request do
  let(:patient) { create(:patient) }
  let(:reason) { create(:admissions_request_reason, description: "XYZ") }
  let(:user) { @current_user }
  let(:time) { Time.zone.now }

  describe "GET index" do
    it "lists patients with an admission request" do
      create(:admissions_request,
             reason: reason,
             updated_by: user,
             created_by: user,
             patient: patient,
             created_at: time,
             updated_at: time)

      get admissions_requests_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("XYZ")
      expect(response.body).to include(@current_user.to_s)
      expect(response.body).to include(I18n.l(time))
      expect(response.body).to include(patient.to_s)
    end
  end

  describe "GET new" do
    it "renders a form" do
      get new_admissions_request_path

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    context "with valid data" do
      it "creates a new Admissions::Request" do
        params = {
          admissions_request: {
            reason_id: reason.id,
            patient_id: patient.id
          }
        }

        expect{
          post(admissions_requests_path, params: params)
        }.to change(Renalware::Admissions::Request, :count).by(1)

        follow_redirect!
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid data ie reason not selected" do
      it "creates re-renders the new template with errors" do
        params = {
          admissions_request: {
            patient_id: patient.id
          }
        }

        expect{
          post(admissions_requests_path, params: params)
        }.to_not change(Renalware::Admissions::Request, :count)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end
  end
end
