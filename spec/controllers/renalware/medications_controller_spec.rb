require "rails_helper"

module Renalware
  RSpec.describe PatientsController, type: :controller do
    subject { create(:patient) }

    describe "GET index" do
      it "returns http success" do
        get :index, id: subject.id

        expect(response).to have_http_status(:success)
      end
    end
  end
end
