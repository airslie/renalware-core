# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Creating an Echo event", js: true do
  include SlimSelectHelper

  context "with valid inputs" do
    it "creates the Echo event" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      create(:heroic_echo_event_type)
      visit renalware.new_patient_event_path(patient)

      slim_select "Echo", from: "* Event type"

      # This should have brought in some new Echo fields
      select "1", from: "Visit number"
      fill_in "LA vol", with: "0.1"
      fill_in "LVIDd 2D", with: 1.1
      fill_in "IVSd 2D", with: 2.2
      fill_in "PWd 2D", with: 3.3
      fill_in "LV ED vol", with: 4.4
      fill_in "RA area", with: 5.5
      fill_in "RV diameter", with: 6.6
      fill_in "TAPSE", with: 7.7
      fill_in "Estimated LVF", with: 8.8
      fill_in "Estimated RVSP", with: 9.9
      fill_in "Valve Pathology", with: "valve pathology"
      click_on "Save"

      expect(page).to have_current_path(renalware.patient_events_path(patient))
      echo = Renalware::Events::Event.where(patient: patient).last
      expect(echo.document).to have_attributes(
        visit_number: 1,
        la_vol: 0.1,
        lvidd_2d: 1.1,
        ivsd_2d: 2.2,
        pwd_2d: 3.3,
        lv_ed_vol: 4.4,
        ra_area: 5.5,
        rv_diameter: 6.6,
        tapse: 7.7,
        estimated_lvf: 8.8,
        estimated_rvsp: 9.9,
        valve_pathology: "valve pathology"
      )
    end
  end
end
