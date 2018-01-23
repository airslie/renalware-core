require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Creating an event", type: :feature, js: true do
  include AjaxHelpers

  context "when adding a biopsy event" do
    it "captures extra data" do
      page.driver.add_headers("Referer" => root_path)
      user = login_as_clinical
      patient = create(:patient, by: user)

      event_type = create(:biopsy_event_type)

      visit new_patient_event_path(patient)

      select "Renal biopsy", from: "Event type"
      select "De Novo GN", from: "Rejection"
      select "26-50%", from: "IFTA"

      click_on "Save"

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)

      # These two fields are defined in the Events::Biopsy::Document
      expect(event.document.result1).to eq("de_novo_gn")
      expect(event.document.result2).to eq("from_26_to_50")
    end
  end
end
