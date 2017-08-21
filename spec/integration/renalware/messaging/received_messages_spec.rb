require "rails_helper"

RSpec.describe "Internal received messages for a user", type: :request do

  describe "GET index" do
    it "responds successfully" do
      get messaging_received_messages_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end
end
