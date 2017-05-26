require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Creating an event", type: :feature, js: true do
  include AjaxHelpers
  before do
    login_as_clinician
    page.driver.add_headers("Referer" => root_path)
  end

  let(:patient) { create(:patient) }

  context "adding a biopsy event" do
    it "captures extra data" do
      event_type = create(:events_type,
                          name: "Renal biopsy",
                          event_class_name: "Renalware::Events::Biopsy")

      visit new_patient_event_path(patient)

      select "Renal biopsy", from: "Event type"
      select "De Novo GN", from: "Rejection"
      select "26-50%", from: "IFTA"

      click_on "Save"

      expect(current_path).to eq(root_path)

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)

      # These two fields are defined in the Events::Biopsy::Document
      expect(event.document.result1).to eq("m")
      expect(event.document.result2).to eq("y")
    end
  end
end
