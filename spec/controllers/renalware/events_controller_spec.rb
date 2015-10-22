require 'rails_helper'

module Renalware
  RSpec.describe EventsController, :type => :controller do

    before do
      @patient = create(:patient)
      @event_type = create(:event_type)
    end

    describe 'GET new' do
      it 'renders the new template' do
        get :new, patient_id: @patient.id
        expect(response).to render_template(:new)
      end
    end

    describe 'POST create' do
      context "with valid attributes" do
        it 'creates a new event' do
          expect { post :create, patient_id: @patient,
            event: {
              event_type_id: @event_type,
              date_time: Time.now,
              description: "Needs blood test",
              notes: "Arrange appointment in a weeks time."
            }
          }.to change(Event, :count).by(1)
          expect(response).to redirect_to(patient_events_path(@patient))
        end
      end

      context "with invalid attributes" do
        it 'creates a new event' do
          expect { post :create, patient_id: @patient.id,
            event: {
              patient: @patient,
              event_type: nil
            }
          }.to change(Event, :count).by(0)
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'GET index' do
      it 'responds with success' do
        get :index, patient_id: @patient
        expect(response).to have_http_status(:success)
      end
    end

  end
end
