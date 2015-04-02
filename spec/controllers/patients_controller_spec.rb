require 'rails_helper'

RSpec.describe PatientsController, :type => :controller do

  # When a doctor checks a terminate box a soft delete is triggered.
  # And the deleted_at value is not nil.

  before do
    @patient = FactoryGirl.create(:patient)
  end

  describe "PATCH update" do

    it "should redirect when the patient is updated" do
      patch :update, id: @patient.id, patient: { patient_medications_attributes: {} }
      expect(response).to have_http_status(:found)
    end

    it "should render the form when update fails" do
      patch :update, id: @patient.id, patient: { forename: " " }
      expect(response).to have_http_status(:success)
    end

  end

  describe "GET manage_medications" do
    it "returns http success" do
      get :manage_medications, id: @patient.id
      expect(response).to have_http_status(:success)
    end
  end

end
