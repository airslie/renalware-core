# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Searching people", type: :system do
  describe "GET index" do
    before do
      user = login_as_clinical
      create(:directory_person, given_name: "Yosemite", family_name: "Sam", by: user)
      create(:directory_person, family_name: "::another patient::", by: user)

      visit directory_people_path
    end

    context "with a name filter" do
      it "responds with a filtered list of people" do
        fill_in "Name contains", with: "sam"
        click_on "Filter"

        within("table.people") do
          expect(page).to have_content("Yosemite")
        end
      end
    end
  end
end
