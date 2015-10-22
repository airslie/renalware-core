require 'rails_helper'

module Renalware
  RSpec.describe PatientsController, :type => :controller do

    # When a doctor checks a terminate box a soft delete is triggered.
    # And the deleted_at value is not nil.

    subject { create(:patient) }

    describe 'GET new' do
      it 'renders the new template' do
        get :new
        expect(response).to render_template('new')
      end
    end

    describe 'POST create' do
      context "with valid attributes" do
        it 'creates a new patient' do
          expect {
            post :create,
            patient: {
              nhs_number: "1234567890",
              surname: "Joe",
              forename: "Bloggs",
              local_patient_id: "123456",
              sex: "Male",
              birth_date: "02/02/1935"
            }
          }.to change(Patient, :count).by(1)
          expect(response).to redirect_to :action => :show, :id => assigns(:patient).id
        end
      end

      context "with invalid attributes" do
        it 'creates a new patient' do
          expect { post :create, patient: { nhs_number: nil } }.to change(Patient, :count).by(0)
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'GET show' do
      it 'responds with success' do
        get :show, id: subject.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH update" do
      it "should redirect when the patient is updated" do
        patch :update, id: subject.id, patient: { patient_medications_attributes: {} }
        expect(response).to have_http_status(:found)
      end

      it "should render the form when update fails" do
        patch :update, id: subject.id, patient: { forename: " " }
        expect(response).to have_http_status(:success)
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

    describe 'problems' do
      it 'responds with success' do
        get :problems, id: subject.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET manage_medications" do
      it "returns http success" do
        get :manage_medications, id: subject.id
        expect(response).to have_http_status(:success)
      end
    end

  end
end
