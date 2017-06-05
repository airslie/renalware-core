require "rails_helper"

module Renalware
  feature "PD Training Session management", js: true do
    ###
    scenario "Add a PD Training Session" do
      patient = create(:pd_patient)
      login_as_clinician

      visit patient_pd_dashboard_path(patient)

      # Summary
      click_link "Add"
      click_link "PD Training Session"

      # New
      started_on = I18n.l(Time.zone.today)
      within(".training_session_document_training_site") { choose("Home") }
      within(".training_session_document_training_type") { choose("APD Baxter") }
      fill_in input_called(:trainer), with: "Flo Nightengale RN"
      fill_in input_called(:started_on), with: Time.zone.today


      click_on "Save"

      expect(page.current_path).to eq(patient_pd_dashboard_path(patient))

      # Summary
      within ".pd_training_sessions table tbody" do
        expect(page).to have_content("Home")
        expect(page).to have_content(started_on)
      end
    end

    def input_called(att)
      PD::TrainingSession::Document.human_attribute_name(att)
    end

    ###
    scenario "Edit a PD Training Session" do
      patient = create(:pd_patient)
      user = login_as_clinician
      create(:pd_training_session,
             patient: patient,
             created_by: user,
             updated_by: user)

      visit patient_pd_dashboard_path(patient)

      # Summary
      within ".pd_training_sessions table tbody" do
        click_on "Edit"
      end

      # Edit - change a couple of fields
      within(".training_session_document_outcome") { choose("successful") }

      click_on "Save"

      # Summary
      within ".pd_training_sessions table tbody" do
        expect(page).to have_content("Successful")
        # We don't need to test all fields, just that the ones we changed have updated.
      end
    end

    ###
    scenario "View a PD Training Session" do
      patient = create(:pd_patient)
      user = login_as_clinician
      training_session = create(:pd_training_session,
                          patient: patient,
                          created_by: user,
                          updated_by: user)

      visit patient_pd_dashboard_path(patient)

      # Summary
      within ".pd_training_sessions table tbody" do
        click_on "View"
      end

      # View
      doc = training_session.document
      within "article.pd_training_session_document" do
        expect(page).to have_content(I18n.l(doc.started_on))
        # No need to test presence of all items here - we just want to make
        # we are are in the right place and some is being displayed.
      end
    end
  end
end
