require "rails_helper"

RSpec.describe "User feedback", type: :feature do
  let(:user) { create(:user, :unapproved, :clinician) }

  describe "GET new html" do
    it "displays the beta banner if config setting is true" do
      Renalware.config.display_feedback_banner = true
      visit root_path
      expect(page).to have_content(I18n.t("renalware.beta_message.title"))
      expect(page).to have_content(I18n.t("renalware.beta_message.body"))
      expect(page).to have_content(I18n.t("renalware.beta_message.feedback_button"))
    end

    it "does not show the beta banner if config setting is false" do
      Renalware.config.display_feedback_banner = false
      visit root_path
      expect(page).not_to have_content(I18n.t("renalware.beta_message.title"))
      expect(page).not_to have_content(I18n.t("renalware.beta_message.body"))
      expect(page).not_to have_content(I18n.t("renalware.beta_message.feedback_button"))
    end

    context "when inputs are valid" do
      it "user offers feedback about the application" do
        login_as_clinician
        visit new_system_user_feedback_path

        expect(page.status_code).to eq(200)
        expect(page).to have_content("Feedback")

        select "Bug", from: "Category"
        fill_in "Comment", with: "My commment"
        click_on "Submit"

        expect(page.status_code).to eq(200)
        expect(page).to have_content("Feedback registered, thank you")
      end
    end
  end
end
