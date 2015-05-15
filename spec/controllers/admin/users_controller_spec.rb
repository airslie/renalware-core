require 'rails_helper'

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

    it 'filters approved users' do
      create(:user)
      create(:user,:approved)

      get :index, approved: 'false'

      expect(assigns(:users)).not_to eq(User.all)
    end
  end
end
