# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage HEROIC study" do
  describe "Viewing the study summary" do
    it do
      user = login_as_admin
      study = create(:heroic_research_study, by: user)
      page = Pages::Heroic::Research::Participations.new(study)
      page.go

      expect(page).to have_content("HEROIC")
    end
  end

  describe "Editing the study settings" do
    context "with invalid inputs" do
      it "renders the errors and does not save" do
        user = login_as_admin
        study = create(:heroic_research_study, by: user)
        visit renalware.edit_research_study_path(study)

        expect(page).to have_content("HEROIC")

        fill_in "Description", with: "" # required
        click_on "Save"

        expect(page).to have_css("small.error")
      end
    end

    context "with valid inputs" do
      it "saves successfully" do
        user = login_as_admin
        study = create(:heroic_research_study, by: user)
        visit renalware.edit_research_study_path(study)

        expect(page).to have_content("HEROIC")
        fill_in "Description", with: "something"
        click_on "Save"

        expect(page).not_to have_css("small.error")
        expect(page).to have_current_path(renalware.research_study_path(study))
        expect(page).to have_content("something")
      end
    end
  end
end
