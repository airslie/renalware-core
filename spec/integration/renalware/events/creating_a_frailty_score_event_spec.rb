# frozen_string_literal: true

require "rails_helper"

describe "Creating an clinical frailty score event", type: :system, js: true do
  context "when adding the event" do
    it "allows a user to also select the score from an event-specific dropdown" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      event_type = create(:clinical_frailty_score)

      visit new_patient_event_path(patient)

      select "Clinical Frailty Score", from: "Event type"
      select "9", from: "Score"

      click_on t("btn.save")

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.event_type_id).to eq(event_type.id)

      # NB #score is defined in the FrailtyScore::Document and the list of options
      # is on an i18n yml file.
      expect(event.document.score).to eq("9")
    end
  end
end
