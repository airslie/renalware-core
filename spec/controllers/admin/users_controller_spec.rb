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
  end

  describe 'GET unapproved' do
    it 'list unapproved users' do
      expect(User).to receive(:unapproved).and_return([])

      get :unapproved
    end
  end

  describe 'GET expired' do
    it 'lists expired users' do
      expect(User).to receive(:expired).and_return([])

      get :expired
    end
  end
end
