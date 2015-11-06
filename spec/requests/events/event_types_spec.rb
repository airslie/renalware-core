require "rails_helper"

RSpec.describe "Configuring Event Types", type: :request do
  let(:event_type) { create(:events_type) }

  describe "GET new" do
    it "responds with a form" do
      get new_events_type_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = {name: "My Event"}
        post events_types_path, events_type: attributes
        expect(response).to have_http_status(:redirect)

        event_type = Renalware::Events::Type.find_by(attributes)
        expect(event_type).to be_present

        follow_redirect!
        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = {name: ""}
        post events_types_path, events_type: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_events_type_path(event_type)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = {name: "My Edited Event"}
        patch events_type_path(event_type), events_type: attributes
        expect(response).to have_http_status(:redirect)

        event_type = Renalware::Events::Type.find_by(attributes)
        expect(event_type).to be_present

        follow_redirect!
        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = {name: ""}
        patch events_type_path(event_type), events_type: attributes
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the event type" do
      delete events_type_path(event_type)
      expect(response).to have_http_status(:redirect)

      deleted_event_type = Renalware::Events::Type.find_by(id: event_type.id)
      expect(deleted_event_type).to_not be_present

      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end

  it "updates an event type" do
    get edit_events_type_path(@event_type.id)
    expect(response).to have_http_status(:success)

    attributes = {name: "My Edited Event"}
    put events_type_path, events_type: attributes
    expect(response).to have_http_status(:redirect)

    event_type = Renalware::Events::Type.find_by(attributes)
    expect(event_type).to be_present

    follow_redirect!
    expect(response).to have_http_status(:success)
  end

  it "destroys an event type" do
    delete events_type_path(@event_type.id)
    expect(response).to have_http_status(:redirect)

    event_type = Renalware::Events::Type.find_by(id: @event_type.id)
    expect(event_type).to_not be_present

    follow_redirect!
    expect(response).to have_http_status(:success)
  end

end
