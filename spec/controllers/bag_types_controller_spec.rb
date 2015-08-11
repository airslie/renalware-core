require 'rails_helper'

RSpec.describe BagTypesController, :type => :controller do

  before do
    @bag_type = create(:bag_type)
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it 'creates a new bag type' do
        expect {
          post :create,
          bag_type: {
            manufacturer: "Baxter",
            description: "Green Bag",
            glucose_grams_per_litre: 15.7
          }
        }.to change(BagType, :count).by(1)
        expect(response).to redirect_to(bag_types_path)
      end
    end

    context "with invalid attributes" do
      it 'creates a new bag type' do
        expect { post :create, bag_type: { description: nil } }.to change(BagType, :count).by(0)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do

    context "with valid attributes" do
      it 'updates a bag type' do
        put :update, id: @bag_type.id, bag_type: { description: "Yellow Bag" }
        expect(response).to redirect_to(bag_types_path)
      end
    end

    context "with invalid attributes" do
      it 'update a bag type' do
        put :update, id: @bag_type.id, bag_type: { description: nil }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'returns http success' do
      delete :destroy, id: @bag_type.id
      @bag_type.reload
      expect(@bag_type.deleted_at).not_to be nil
      expect(response).to have_http_status(:found)
    end
  end

end
