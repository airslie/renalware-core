require "rails_helper"

RSpec.describe "Read internal messages for a user", type: :request do
  describe "GET read" do
    it "responds successfully" do
      get messaging_internal_read_receipts_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:read)
    end
  end
end
