require "rails_helper"

RSpec.describe "Configuring Event Types", type: :request do
  before do
    @event_type = create(:events_type)
  end

  it "creates an event type" do
    get new_events_type_path
    expect(response).to have_http_status(:success)

    attributes = {name: "My Event"}
    post events_types_path, events_type: attributes
    expect(response).to have_http_status(:redirect)

    event_type = Renalware::Events::Type.find_by(attributes)
    expect(event_type).to be_present

    follow_redirect!
    expect(response).to have_http_status(:success)
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
