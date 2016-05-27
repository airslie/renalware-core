require "rails_helper"

RSpec.describe "Listing Modality Reasons", type: :request do

  describe "GET index" do
    it "responds with a list" do
      create(:pd_to_haemodialysis, description: "::modality name::" )

      get modalities_reasons_path

      expect(response).to have_http_status(:success)
      expect(response.body).to match("::modality name::")
    end
  end
end
