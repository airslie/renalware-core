# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage HEROIC participants", :js do
  describe "Viewing the particpants" do
    it do
      user = login_as_admin
      study = create(:heroic_research_study, by: user)
      create(:research_investigatorship, user: user, study: study, by: user)
      visit research.study_path(study)
      click_on "Participants"

      expect(page).to have_current_path(research.study_participations_path(study))
    end
  end

  describe "adding a participant to the study" do
    context "with invalid inputs" do
      it "renders the errors and does not save" do
        user = login_as_admin
        study = create(:heroic_research_study, by: user)
        create(:research_investigatorship, user: user, study: study, by: user)
        visit research.study_participations_path(study)
        within ".filter-actions" do
          click_on "Add"
        end

        expect(page).to have_current_path(research.new_study_participation_path(study))

        click_on "Save"

        expect(page).to have_css("small.error")
      end
    end

    context "with valid inputs" do
      it "saves successfully including the custom document attributes" do
        user = login_as_admin
        study = create(:heroic_research_study, by: user)
        create(:research_investigatorship, user: user, study: study, by: user)
        patient = create(:patient)
        visit research.study_participations_path(study)
        within ".filter-actions" do
          click_on "Add"
        end

        slim_select(
          patient.to_s(:long),
          from: "participation_patient_id",
          wait_for: "Enter at least 3 characters"
        )
        fill_in "Study number", with: "123"
        fill_in "Joined on", with: I18n.l(Time.zone.today)
        fill_in "Left on", with: I18n.l(Time.zone.today)
        fill_in "Education", with: "12"
        click_on "Save"

        expect(page).to have_no_css("small.error")
        expect(page).to have_current_path(research.study_participations_path(study))
        expect(study.participations.length).to eq(1)
        participation = study.participations.first
        expect(participation.document.study_number).to eq("123")
        expect(participation.document.demographics.education).to eq(12)
      end
    end
  end
end
