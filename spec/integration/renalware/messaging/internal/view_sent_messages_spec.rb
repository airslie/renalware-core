require "rails_helper"

RSpec.describe "Internal sent messages for a user", type: :request do
  describe "GET sent" do
    it "responds successfully" do
      get messaging_internal_sent_messages_path

      expect(response).to have_http_status(:success)
    end
  end
end
