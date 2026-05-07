# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Creating an MRI event", js: true do
  include DocumentTranslations
  include SlimSelectHelper

  context "with valid inputs" do
    it "creates the event" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      create(:heroic_mri_event_type)
      visit renalware.new_patient_event_path(patient)

      slim_select "MRI", from: "* Event type"

      document = build(:heroic_mri_event).document
      fill_in(
        document_t(document, :lv_global_diastolic_circumferential_strain_rate_continuous),
        with: "1.1"
      )

      fill_in "Visit number", with: "1"
      # Ignore other fields for now

      click_on "Save"

      # expect(page).to have_current_path(renalware.patient_events_path(patient))
      event = Renalware::Events::Event.where(patient: patient).last
      expect(event.document).to have_attributes(
        visit_number: 1,
        lv_global_diastolic_circumferential_strain_rate_continuous: 1.1
      )
    end
  end
end
