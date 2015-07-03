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
end
