require "rails_helper"

RSpec.describe "requests Requests", type: :request do
  describe "GET index" do
    let!(:request_1) { create(:pathology_requests_request) }
    let!(:request_2) { create(:pathology_requests_request) }

    it "responds with a list of request forms" do
      get pathology_requests_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    let!(:request) { create(:pathology_requests_request) }

    it "responds with a list of request forms" do
      get pathology_request_path(id: request.id, format: "pdf")

      expect(response).to have_http_status(:success)
      expect(response.headers["Content-Type"]).to eq("application/pdf")
    end
  end
end
