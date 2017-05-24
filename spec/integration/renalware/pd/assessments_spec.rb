require "rails_helper"

module Renalware
  feature "PD Assessment management", js: true do
    scenario "Adding a PD Assessment" do
      patient = create(:pd_patient)
      login_as_clinician

      visit patient_pd_dashboard_path(patient)
      click_link "Add"
      click_link "PD Assessment"

      home_visit_on = I18n.l(Time.zone.now)
      within(".assessment_document_had_home_visit") { choose("Yes") }
      within(".assessment_document_housing_type") { choose("Patient") }
      fill_in input_called(:home_visit_on), with: home_visit_on
      fill_in input_called(:occupant_notes), with: "occupant_notes"
      fill_in input_called(:exchange_area), with: "exchange_area"
      fill_in input_called(:handwashing), with: "handwashing"
      fill_in input_called(:bag_warming), with: "bag_warming"
      fill_in input_called(:fluid_storage), with: "bag_warming"
      fill_in input_called(:delivery_frequency), with: "delivery_frequency"

      click_on "Save"

      within ".pd_assessments table tbody" do
        expect(page).to have_content("Yes")
        expect(page).to have_content(home_visit_on)
      end
    end

    def input_called(att)
      PD::Assessment.human_attribute_name(att)
    end

    scenario "Editing a PD Assessment" do
      patient = create(:pd_patient)
      user = login_as_clinician
      create(:pd_assessment,
                          patient: patient,
                          created_by: user,
                          updated_by: user)

      visit patient_pd_dashboard_path(patient)
      within ".pd_assessments table tbody" do
        click_on "Edit"
      end
    end
  end
end
