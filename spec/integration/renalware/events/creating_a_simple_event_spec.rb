# frozen_string_literal: true

require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Creating an event", type: :feature, js: true do
  include AjaxHelpers

  context "when adding a simple event" do
    it "works" do
      page.driver.add_headers("Referer" => root_path)
      user = login_as_clinical
      patient = create(:patient, by: user)

      event_type = create(:access_clinic_event_type, name: "Access--Clinic")
      visit new_patient_event_path(patient)

      select "Access--Clinic", from: "Event type"
      wait_for_ajax
      expect(page).to have_content("Description")

      fill_in "Description", with: "Test"
      click_on "Save"

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)
      expect(event.description).to eq("Test")
    end
  end
end
