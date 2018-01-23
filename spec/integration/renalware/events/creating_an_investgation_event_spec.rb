require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Creating a investigation event", type: :feature, js: true do
  include AjaxHelpers

  context "when adding a investigation event" do
    it "captures extra data" do
      page.driver.add_headers("Referer" => root_path)
      user = login_as_clinical
      patient = create(:patient, by: user)

      create(:investigation_event_type)

      visit new_patient_event_path(patient)

      select "Investigation", from: "Event type"
      wait_for_ajax
      select "Dental Check", from: "Type"
      fill_in "Result", with: "result"
      sleep 1
      fill_in_trix_editor("events_event_notes_trix_input_events_investigation", "notes")

      click_on "Save"

      # events = Renalware::Events::Event.for_patient(patient)
      # expect(events.length).to eq(1)
      # event = events.first
      # expect(event.event_type_id).to eq(event_type.id)

      # # These two fields are defined in the Events::Biopsy::Document
      # expect(event.document.result1).to eq("de_novo_gn")
      # expect(event.document.result2).to eq("from_26_to_50")
    end
  end
end
