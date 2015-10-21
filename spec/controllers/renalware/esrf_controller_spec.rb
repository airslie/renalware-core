require 'rails_helper'

module Renalware
  RSpec.describe ESRFController, :type => :controller , class: ESRFController do

    before do
      @patient = FactoryGirl.create(:patient)
      @esrf = FactoryGirl.create(:esrf)
    end

    describe 'GET edit' do
      it 'responds with success' do
        get :edit, id: @esrf.id, patient_id: @patient.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PUT update' do
      context "with valid attributes" do
        it 'updates an esrf' do
          put :update, id: @esrf.id, patient_id: @patient.id, esrf: {
            diagnosed_on: Time.now
          }
          expect(response).to redirect_to(patient_clinical_summary_path(@patient))
        end
      end

      context "with invalid attributes" do
        it 'update an esrf' do
          put :update, id: @esrf.id, patient_id: @patient.id, esrf: {
            diagnosed_on: nil
          }
          expect(response).to render_template(:edit)
        end
      end
    end

  end
end
