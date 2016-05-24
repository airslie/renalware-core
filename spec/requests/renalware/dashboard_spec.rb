require "rails_helper"

RSpec.describe "User's Dashboard", type: :request do
  let(:user) { create(:user) }

  describe "GET show" do
    it "responds with the dashboard page" do
      get dashboard_path

      expect(response).to have_http_status(:success)
      # TODO: Populate the dashboard page with something
      expect(response.body).to include("<h4>TODO:</h4>")
    end
  end
end
