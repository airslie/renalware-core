# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Toggling mGFR events", :js do
  include DocumentTranslations
  include SlimSelectHelper

  context "when toggling open an mGFR event table row" do
    it "displays a summarised view of the event" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      event = create(:heroic_mgfr_event, patient: patient, by: user)
      document = event.document

      visit renalware.patient_events_path(patient)

      within(".events-table") do
        # The untoggled row
        expect(page).to have_text("mGFR")
        expect(page).to have_text(document.visit_number)

        click_on "Toggle"

        # The toggled row
        document.attributes.each_key do |attr_name|
          expect(page).to have_text(document_t(document, attr_name))
          expect(page).to have_text(document.public_send(attr_name))
        end
      end
    end
  end
end
