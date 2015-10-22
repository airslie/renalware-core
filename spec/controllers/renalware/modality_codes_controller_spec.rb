require 'rails_helper'

module Renalware
  describe ModalityCodesController, :type => :controller do

    subject { create(:modality_code) }

    describe 'GET new' do
      it 'renders the new template' do
        get :new
        expect(response).to render_template('new')
      end
    end

    describe 'POST create' do
      context "with valid attributes" do
        it 'creates a new modality code' do
          expect {
            post :create,
            modality_code: {
              code: "diabetic",
              name: "Renal/Diabetic"
            }
          }.to change(ModalityCode, :count).by(1)
          expect(response).to redirect_to(modality_codes_path)
        end
      end

      context "with invalid attributes" do
        it 'creates a new modality code' do
          expect { post :create, modality_code: { code: nil, name: nil } }.to change(ModalityCode, :count).by(0)
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'GET index' do
      it 'responds with success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET edit' do
      it 'responds with success' do
        get :edit, id: subject.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PUT update' do
      context "with valid attributes" do
        it 'updates a modality code' do
          put :update, id: subject.id, modality_code: { name: "Low Clearance" }
          expect(response).to redirect_to(modality_codes_path)
        end
      end

      context "with invalid attributes" do
        it 'update a modality code' do
          put :update, id: subject.id, modality_code: { name: nil }
          expect(response).to render_template(:edit)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'soft deletes a modality code' do
        @modality_code = create(:modality_code)

        expect { delete :destroy, id: @modality_code }.to change(ModalityCode, :count).by(-1)

        expect(@modality_code.reload.deleted_at).not_to be_nil
      end
    end

  end
end