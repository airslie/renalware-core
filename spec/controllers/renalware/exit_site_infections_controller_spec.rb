require 'rails_helper'

module Renalware
  RSpec.describe ExitSiteInfectionsController, :type => :controller do

    before do
      @patient = FactoryGirl.create(:patient)
    end

    subject { create(:exit_site_infection) }

    describe 'GET new' do
      it 'renders the new template' do
        get :new, patient_id: @patient.id
        expect(response).to render_template('new')
      end
    end

    describe 'POST create' do
      context "with valid attributes" do
        it 'creates a new exit site infection' do
          expect {
            post :create,
            patient_id: @patient.id,
            exit_site_infection: {
              diagnosis_date: "21/06/#{Date.current.year}"
            }
          }.to change(ExitSiteInfection, :count).by(1)
          expect(response).to redirect_to(pd_info_patient_path(@patient))
        end
      end

      context "with invalid attributes" do
        it 'creates a new exit site infection' do
          expect {
            post :create,
            patient_id: @patient.id,
            exit_site_infection: {
              diagnosis_date: nil
            }
          }.to change(ExitSiteInfection, :count).by(0)
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'GET show' do
      it 'responds with success' do
        get :show, id: subject.id, patient_id: @patient.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET edit' do
      it 'responds with success' do
        get :edit, id: subject.id, patient_id: @patient.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PUT update' do
      context "with valid attributes" do
        it 'updates an exit site infection' do
          put :update, id: subject.id,
          patient_id: @patient.id,
          exit_site_infection: {
            diagnosis_date: "25/06/#{Date.current.year}"
          }
          expect(response).to redirect_to(pd_info_patient_path(@patient))
        end
      end

      context "with invalid attributes" do
        it 'update an exit site infection' do
          put :update, id: subject.id,
          patient_id: @patient.id,
          exit_site_infection: {
            diagnosis_date: nil
          }
          expect(response).to render_template(:edit)
        end
      end
    end

  end
end