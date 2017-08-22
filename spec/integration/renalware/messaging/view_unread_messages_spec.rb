require "rails_helper"

RSpec.describe "View internal messages sent by the current", type: :request do

  describe "GET index" do
    it "responds successfully" do
      get messaging_inbox_path

      expect(response).to have_http_status(:success)
    end
  end
end
