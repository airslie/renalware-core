require "rails_helper"

RSpec.describe "Viewing patients whose HD preferences do not match their profile", type: :request do

  describe "GET index" do
    it "responds with a list of patients" do

      get hd_unmet_preferences_path

      expect(response).to have_http_status(:success)
    end
  end
end
