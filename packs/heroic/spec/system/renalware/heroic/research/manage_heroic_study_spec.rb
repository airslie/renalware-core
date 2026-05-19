# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage HEROIC study" do
  describe "Viewing the study summary" do
    it do
      user = login_as_admin
      study = create(:heroic_research_study, by: user)
      page = Pages::Heroic::Research::Participations.new(study)
      page.go

      expect(page).to have_text("HEROIC")
    end
  end

  describe "Editing the study settings" do
    context "with invalid inputs" do
      it "renders the errors and does not save" do
        user = login_as_admin
        study = create(:heroic_research_study, by: user)
        visit research.edit_study_path(study)

        expect(page).to have_text("HEROIC")

        fill_in "Description", with: "" # required
        click_on "Save"

        expect(page).to have_css("small.error")
      end
    end

    context "with valid inputs" do
      it "saves successfully" do
        user = login_as_admin
        study = create(:heroic_research_study, by: user)
        visit research.edit_study_path(study)

        expect(page).to have_text("HEROIC")
        fill_in "Description", with: "something"
        click_on "Save"

        expect(page).to have_no_css("small.error")
        expect(page).to have_current_path(research.study_path(study))
        expect(page).to have_text("something")
      end
    end
  end
end
