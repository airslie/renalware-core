require 'rails_helper'

module Renalware
  describe Modalities::ReasonsController, type: :controller do

    describe 'GET index' do
      it 'responds with success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

  end
end
