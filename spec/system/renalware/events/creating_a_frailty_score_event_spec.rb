describe "Creating an clinical frailty score event", :js do
  let(:score_options) do
    [""] +
      Renalware::Events::ClinicalFrailtyScore::Document.score.options.map(&:first)
  end

  context "when adding the event" do
    it "allows a user to also select the score from an event-specific dropdown" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      event_type = create(:clinical_frailty_score_event_type)

      visit new_patient_event_path(patient)

      slim_select "Clinical Frailty Score", from: "Event type"

      expect(page).to have_select "Score", options: score_options
      select "9. Terminally Ill", from: "Score"

      click_on t("btn.create")

      expect(page).to have_current_path(patient_events_path(patient))
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
