# frozen_string_literal: true

require "rails_helper"

module Renalware::Events
  describe EventsController, type: :request do
    class TestEvent < Renalware::Events::Event
    end
    class TestEventPolicy < Renalware::BasePolicy
      def edit?
        false
      end
      alias edit? update?
      alias edit? destroy?
    end

    let(:user) { create(:user) }
    let(:patient) { create(:patient, by: user) }
    let(:event_type) { create(:access_clinic_event_type) }

    describe "GET new" do
      it "renders the new template" do
        get new_patient_event_path(patient)

        expect(response).to be_successful
      end
    end

    describe "POST create" do
      context "with valid attributes" do
        it "creates a new event" do
          attributes = {
            event_type_id: event_type.id,
            date_time: Time.zone.now.round.to_s,
            description: "Needs blood test",
            notes: "Arrange appointment in a weeks time."
          }

          post patient_events_path(patient), params: { events_event: attributes }

          expect(response).to have_http_status(:redirect)
          follow_redirect!
          expect(response).to be_successful
          expect(response).to render_template(:index)
        end
      end

      context "with invalid attributes" do
        it "creates a new event" do
          attributes = {
            event_type_id: nil,
            date_time: Time.zone.now.round.to_s,
            description: "Needs blood test",
            notes: "Arrange appointment in a weeks time."
          }

          post patient_events_path(patient), params: { events_event: attributes }

          expect(response).to be_successful
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET index" do
      it "responds with success" do
        get patient_events_path(patient)

        expect(response).to be_successful
        expect(response).to render_template(:index)
      end
    end

    describe "GET edit" do
      let(:event) { create(:event, type: "Renalware::Events::TestEvent", patient: patient) }

      context "when the event policy does not permit editing" do
        it "does not allow access to the edit form" do
          allow_any_instance_of(TestEventPolicy).to receive(:edit?).and_return(false)

          get edit_patient_event_path(patient, event)

          expect(response).to have_http_status(:redirect)
          follow_redirect!
          expect(response).not_to render_template(:edit)
        end
      end

      # TODO: Cannot test this as of course we get
      #   Missing partial renalware/events/events/inputs/_test_event
      #
      # context "when the event policy permits editing" do
      #   it "allows access to the edit form" do
      #     allow_any_instance_of(TestEventPolicy).to receive(:edit?).and_return(true)

      #     get edit_patient_event_path(patient, event)

      #     expect(response).to be_successful
      #     expect(response).to render_template(:edit)
      #   end
      # end
    end

    describe "DELETE destroy" do
      let(:event) { create(:event, type: "Renalware::Events::TestEvent", patient: patient) }

      context "when the event policy does not permit destroy" do
        it "does not succeed" do
          allow_any_instance_of(TestEventPolicy).to receive(:destroy?).and_return(false)

          delete patient_event_path(patient, event)

          expect(response).to have_http_status(:redirect)
          follow_redirect!
          expect(response).not_to render_template(:index)
        end
      end

      context "when the event policy permits editing" do
        it "allows access to the edit form" do
          allow_any_instance_of(TestEventPolicy).to receive(:destroy?).and_return(true)

          delete patient_event_path(patient, event)

          expect(response).to have_http_status(:redirect)
          follow_redirect!
          expect(response).to render_template(:index)
        end
      end
    end
  end
end
