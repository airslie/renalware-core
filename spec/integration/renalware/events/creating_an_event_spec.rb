require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Creating an event", type: :feature, js: true do
  include AjaxHelpers
  before do
    login_as_clinician
    page.driver.add_headers("Referer" => root_path)
  end

  let(:patient) { create(:patient) }

  context "adding a simple event" do
    it "works" do
      # event_type = create(:events_type, name: "Access clinic")
      create(:events_type, name: "Access clinic")
      visit new_patient_event_path(patient)

      # select "Access clinic", from: "Event type"
      expect(page).to have_content("Description")
      fill_in "Description", with: "Test"

      click_on "Save"

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      # expect(event.event_type_id).to eq(event_type.id)
      expect(event.description).to eq("Test")
    end
  end

  context "adding a biopsy event" do
    it "captures extra date" do
      event_type = create(:events_type,
                          name: "Renal biopsy",
                          event_class_name: "Renalware::Events::Biopsy")

      visit new_patient_event_path(patient)

      select "Renal biopsy", from: "Event type"
      select "A", from: "Result 1"
      select "Z", from: "Result 2"

      click_on "Save"

      expect(current_path).to eq(root_path)

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)

      # These two fields are defined in the Events::Biopsy::Document
      expect(event.document.result1).to eq("a")
      expect(event.document.result2).to eq("z")
    end
  end
end
