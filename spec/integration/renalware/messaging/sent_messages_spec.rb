require "rails_helper"

RSpec.describe "Internal sent messages for a user", type: :request do

  describe "GET index" do
    it "responds successfully" do
      get messaging_sent_messages_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end
end
