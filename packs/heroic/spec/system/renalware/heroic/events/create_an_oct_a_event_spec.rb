# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Creating an OctA event", :js do
  include DocumentTranslations
  include SlimSelectHelper

  context "with valid inputs" do
    it "creates the event" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      create(:heroic_oct_a_event_type)

      visit new_patient_event_path(patient)

      slim_select "Retinal screen", from: "* Event type"

      document = Renalware::Heroic::Events::OctA::Document.new
      select "1", from: document_t(document, :visit_number)
      select "Photography", from: document_t(document, :screen_type)
      fill_in document_t(document, :skeletonized_vessel_density_continuous), with: "1.1"
      fill_in document_t(document, :fractal_dimension_continuous), with: "1.1"
      fill_in document_t(document, :vessel_diameter_index_continuous), with: "1.1"
      fill_in document_t(document, :average_vessel_calibre_continuous), with: "1.1"
      fill_in document_t(document, :foveal_avascular_zone_continuous), with: "1.1"
      fill_in document_t(document, :perifoveal_interpapillary_area_continuous), with: "1.1"
      fill_in document_t(document, :number_of_microaneurysms), with: "1"
      within ".events_event_document_diabetic_retinopathy" do
        choose "Yes"
      end

      click_on "Save"

      event = Renalware::Events::Event.where(patient: patient).last
      expect(event.document).to have_attributes(
        visit_number: 1,
        skeletonized_vessel_density_continuous: 1.1,
        fractal_dimension_continuous: 1.1,
        vessel_diameter_index_continuous: 1.1,
        average_vessel_calibre_continuous: 1.1,
        foveal_avascular_zone_continuous: 1.1,
        perifoveal_interpapillary_area_continuous: 1.1,
        number_of_microaneurysms: 1,
        diabetic_retinopathy: "yes"
      )
    end
  end
end
