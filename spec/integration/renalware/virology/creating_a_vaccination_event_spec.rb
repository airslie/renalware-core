require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Creating an vaccination", type: :feature, js: true do
  include AjaxHelpers

  context "when adding a vaccination event" do
    it "captures extra data" do
      page.driver.add_headers("Referer" => root_path)
      user = login_as_clinical
      patient = create(:patient, by: user)

      event_type = create(:vaccination_event_type)

      visit new_patient_event_path(patient)

      select "Vaccination", from: "Event type"
      # .. other stuff here

      click_on "Save"

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)

      # Check document content here
      # expect(...)
    end
  end
end
