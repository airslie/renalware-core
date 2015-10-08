require 'rails_helper'

module Renalware
  RSpec.describe EventTypesController, :type => :controller do

    subject { create(:event_type) }

    describe 'GET #new' do
      it 'renders the new template' do
        get :new
        expect(response).to render_template('new')
      end
    end

    describe 'POST #create' do
      context "with valid attributes" do
        it 'creates a new event type' do
          expect {
            post :create,
            event_type: {
              name: "Iron clinic"
            }
          }.to change(EventType, :count).by(1)
          expect(response).to redirect_to(event_types_path)
        end
      end

      context "with invalid attributes" do
        it 'creates a new event type' do
          expect { post :create, event_type: { name: nil } }.to change(EventType, :count).by(0)
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'GET index' do
      it 'responds successfully' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PUT #update' do
      context "with valid attributes" do
        it 'updates an event type' do
          put :update, id: subject.id, event_type: { name: "Transplant clinic" }
          expect(response).to redirect_to(event_types_path)
        end
      end

      context "with invalid attributes" do
        it 'update an event type' do
          put :update, id: subject.id, event_type: { name: nil }
          expect(response).to render_template(:edit)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'returns http success' do
        delete :destroy, id: subject.id
        subject.reload
        expect(subject.deleted_at).not_to be nil
        expect(response).to have_http_status(:found)
      end
    end

  end
end
