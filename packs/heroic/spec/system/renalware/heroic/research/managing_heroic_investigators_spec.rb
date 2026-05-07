# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage HEROIC investigators" do
  describe "Viewing the investigators" do
    it "displays them in a list" do
      user = login_as_admin
      study = create(:heroic_research_study, by: user)
      investigatorship = create(:heroic_investigatorship, study: study, by: user)
      visit renalware.research_study_path(study)
      click_on "Investigators"

      expect(page).to have_current_path(renalware.research_study_investigatorships_path(study))
      expect(page).to have_text(investigatorship.user.to_s)
    end
  end

  describe "adding an investigator to the study" do
    context "with invalid inputs" do
      it "renders the errors and does not save" do
        user = login_as_super_admin
        study = create(:heroic_research_study, by: user)

        visit renalware.research_study_investigatorships_path(study)
        within ".filter-actions" do
          click_on "Add"
        end

        expect(page).to have_current_path(renalware.new_research_study_investigatorship_path(study))

        click_on "Save"

        expect(page).to have_css("small.error")
      end
    end

    context "with valid inputs", :js do
      it "saves successfully including the custom document attributes" do
        user = login_as_super_admin
        study = create(:heroic_research_study, by: user)
        visit renalware.research_study_investigatorships_path(study)
        within ".filter-actions" do
          click_on "Add"
        end

        select2(user.to_s, css: "#select2-user")
        fill_in("Started on", with: "01-Apr-2018")

        click_on "Save"

        expect(page).to have_no_css("small.error")
        expect(page).to have_current_path(renalware.research_study_investigatorships_path(study))
        expect(study.investigatorships.length).to eq(1)
      end
    end
  end
end
