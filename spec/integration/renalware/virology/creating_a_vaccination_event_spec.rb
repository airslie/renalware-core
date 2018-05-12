# frozen_string_literal: true

require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Creating an vaccination", type: :feature, js: true do
  include AjaxHelpers
  let(:event_date_time) { "08-Feb-2018 07:00" }

  context "when adding a vaccination event through the Events page" do
    it "captures extra data" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      create(:vaccination_event_type)

      visit new_patient_event_path(patient)

      fill_in "Date time", with: event_date_time
      select "Vaccination", from: "Event type"
      wait_for_ajax
      select "HBV Vaccination 1", from: "Type"

      click_on "Save"

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.document.type.text).to eq("HBV Vaccination 1")
      expect(I18n.l(event.date_time)).to eq(event_date_time)
    end
  end

  context "when adding a vaccination through via the virology/vaccinations " do
    it "captures extra data" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      create(:vaccination_event_type)

      visit new_patient_virology_vaccination_path(patient)

      wait_for_ajax
      fill_in "Date time", with: event_date_time
      select "HBV Booster", from: "Type"
      click_on "Save"

      events = Renalware::Virology::Vaccination.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.first
      expect(event.document.type.text).to eq("HBV Booster")
      expect(I18n.l(event.date_time)).to eq(event_date_time)

      # TODO: check we redirect back the virology dashboard
      #       (we don't atm, we go to events/)
    end
  end
end
