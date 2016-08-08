require "rails_helper"

RSpec.describe "requests Requests", type: :request do
  let!(:request_1) { create(:pathology_requests_request) }
  let!(:request_2) { create(:pathology_requests_request) }

  describe "GET index" do
    it "responds with a list of request forms" do
      get pathology_requests_path

      expect(response).to have_http_status(:success)

      expect(response.body).to include(request_1.patient.family_name)
      expect(response.body).to include(request_2.patient.family_name)
    end
  end
end
