require "rails_helper"

RSpec.describe "Configuring Event Types", type: :request do

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
end
