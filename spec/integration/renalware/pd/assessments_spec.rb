require "rails_helper"

module Renalware
  feature "PD Assessment management", js: true do
    scenario "Adding a PD Assessment" do
      patient = create(:pd_patient)
      login_as_clinician

      visit patient_pd_dashboard_path(patient)
      click_link "Add"
      click_link "PD Assessment"

      within(".document_had_home_visit") { choose("Yes") }
      within(".document_housing_type") { choose("Patient") }
      fill_in input_called(:home_visit_on), with: I18n.l(Time.zone.now)
      fill_in input_called(:occupant_notes), with: "occupant_notes"
      fill_in input_called(:exchange_area), with: "exchange_area"
      fill_in input_called(:handwashing), with: "handwashing"
      fill_in input_called(:bag_warming), with: "bag_warming"
      fill_in input_called(:occupant_notes), with: "occupant_notes"
      fill_in input_called(:delivery_frequency), with: "delivery_frequency"

      click_on "Save"

    end

    def input_called(att)
      PD::Assessment.human_attribute_name(att)
    end
  end
end
