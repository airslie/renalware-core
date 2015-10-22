require "rails_helper"

module Renalware
  RSpec.describe DeathsController, type: :controller do
    describe "index" do
      it "responds with success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
