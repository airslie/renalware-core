# frozen_string_literal: true

require "rails_helper"

describe "Beta banner and capturing user feedback", type: :system do
  let(:user) { create(:user, :unapproved, :clinician) }

  describe "beta banner" do
    it "displays the beta banner if config setting is true" do
      Renalware.config.display_feedback_banner = true
      visit root_path
      expect(page).to have_content(I18n.t("renalware.beta_message.title"))
      expect(page).to have_content(I18n.t("renalware.beta_message.body"))
    end

    it "does not show the beta banner if config setting is false" do
      Renalware.config.display_feedback_banner = false
      visit root_path
      expect(page).not_to have_content(I18n.t("renalware.beta_message.title"))
      expect(page).not_to have_content(I18n.t("renalware.beta_message.body"))
    end

    it "does not show the feedback button on the login screen" do
      Renalware.config.display_feedback_banner = true
      visit root_path
      expect(page).not_to have_content(I18n.t("renalware.beta_message.feedback_button"))
    end

    it "shows the feedback button once logged in" do
      Renalware.config.display_feedback_banner = true
      login_as_clinical
      visit root_path
      expect(page).to have_content(I18n.t("renalware.beta_message.feedback_button"))
    end
  end

  describe "GET new html", js: true do
    context "when inputs are valid" do
      it "user offers feedback about the application" do
        login_as_clinical
        visit new_system_user_feedback_path

        expect(page).to have_content("Feedback")

        choose "Missing feature"
        fill_in "Comment", with: "My commment"
        click_on "Submit"

        expect(page).to have_content("Feedback registered, thank you")
      end
    end
  end
end
