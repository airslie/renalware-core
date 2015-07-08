require 'rails_helper'

describe LettersController, type: :controller do
  before do
    @patient = create(:patient)
  end

  describe 'GET new' do
    before do
      get :new, { patient_id: @patient.to_param }
    end

    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the current patient to the letter' do
      expect(assigns(:letter)).not_to be_nil
      expect(assigns(:letter).patient).to eq(@patient)
    end
  end

  describe 'GET index' do
    before do
      create(:letter, patient: @patient)
      get :index, { patient_id: @patient.to_param }
    end

    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).not_to be_nil
      expect(assigns(:letters).first).to be_a(Letter)
      expect(assigns(:letters).first.patient).to eq(@patient)
    end
  end

  describe 'GET author' do
    before do
      @author = create(:user)
      create(:letter, author: @author)
      get :author, { author_id: @author.to_param }
    end

    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns letters' do
      expect(assigns(:letters)).not_to be_nil
      expect(assigns(:letters).first).to be_a(Letter)
      expect(assigns(:letters).first.author).to eq(@author)
    end
  end
end
