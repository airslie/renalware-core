# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Creating an ECG event", js: true do
  include SlimSelectHelper

  context "with valid inputs" do
    it "creates the event" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      create(:heroic_ecg_event_type)
      visit renalware.new_patient_event_path(patient)

      slim_select "ECG", from: "* Event type"

      # This should have brought in some new Echo fields
      select "1", from: "Visit number"

      click_on "Save"

      expect(page).to have_current_path(renalware.patient_events_path(patient))
      echo = Renalware::Events::Event.where(patient: patient).last
      expect(echo.document).to have_attributes(
        visit_number: 1
      )
    end
  end
end
