require "rails_helper"

RSpec.describe "requests Requests", type: :request do
  describe "GET index" do
    let!(:clinic_1) { create(:clinic) }
    let!(:patient_1) { create(:pathology_patient) }
    let!(:consultant_1) { create(:pathology_consultant) }
    let!(:request_1) do
      create(
        :pathology_requests_request,
        clinic: clinic_1,
        patient: patient_1,
        consultant: consultant_1
      )
    end
    let!(:clinic_2) { create(:clinic) }
    let!(:patient_2) { create(:pathology_patient) }
    let!(:consultant_2) { create(:pathology_consultant) }
    let!(:request_2) do
      create(
        :pathology_requests_request,
        clinic: clinic_2,
        patient: patient_2,
        consultant: consultant_2
      )
    end

    it "responds with a list of request forms" do
      get pathology_requests_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    let!(:clinic) { create(:clinic) }
    let!(:patient) { create(:pathology_patient) }
    let!(:consultant) { create(:pathology_consultant) }
    let!(:request) do
      create(
        :pathology_requests_request,
        clinic: clinic,
        patient: patient,
        consultant: consultant
      )
    end

    it "responds with a list of request forms" do
      get pathology_request_path(id: request.id, format: "pdf")

      expect(response).to have_http_status(:success)
      expect(response.headers["Content-Type"]).to eq("application/pdf")
    end
  end
end
