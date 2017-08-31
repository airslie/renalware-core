require "rails_helper"

RSpec.describe "Managing Diaries", type: :request do

  describe "GET new" do
    it "responds with a form" do
      unit = create(:hd_unit)
      get hd_unit_diaries_path(unit)

      expect(response).to have_http_status(:success)
    end
  end
end
