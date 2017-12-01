require "rails_helper"

RSpec.describe "Creating a swab", type: :feature, js: true do
  it "allows creation of a new swab event" do
    user = login_as_read_write
    patient = create(:patient, by: user)
    event_type = create(:swab_event_type)

    visit new_patient_swab_path(patient)

    fill_in_trix_editor(
      "events_event_notes_trix_input_events_swab",
      "notes"
    )

    find("div.radio_buttons", text: "Swab type").choose("MRSA")
    find("div.radio_buttons", text: "Swab result").choose("Positive")

    click_on "Save"

    events = Renalware::Events::Event.for_patient(patient)
    expect(events.length).to eq(1)
    event = events.first
    expect(event.event_type_id).to eq(event_type.id)
    expect(event.document.type).to eq("mrsa")
    expect(event.document.result).to eq("pos")
    expect(event.notes).to eq("notes")
  end
end
