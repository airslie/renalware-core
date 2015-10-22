require "rails_helper"

module Renalware
  RSpec.describe ProblemsController, type: :controller do
    subject { create(:patient) }

    describe "index" do
      it "responds with success" do
        get :index, patient_id: subject.id
        expect(response).to have_http_status(:success)
      end
    end
  end
end
