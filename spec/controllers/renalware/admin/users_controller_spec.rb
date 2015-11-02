require 'rails_helper'

module Renalware
  describe Admin::UsersController, :type => :controller do
    describe 'GET index' do
      it 'responds with success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'assigns users' do
        get :index
        expect(assigns(:users).first).to be_a(User)
      end
    end
  end
end
