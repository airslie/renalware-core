require "rails_helper"

RSpec.describe "Searching people", type: :feature do
  describe "GET index" do
    let(:nurse) { create(:user) }

    before do
      login_as_clinician
      create(:directory_person, given_name: "Roger", family_name: "Rabbit", by: nurse)
      create(:directory_person, family_name: "::another patient::", by: nurse)

      visit directory_people_path
    end

    context "with a partial family name filter" do
      it "responds with a filtered list of people" do
        fill_in "Family or Given Name", with: "abbit"
        click_on "Filter"

        expect(page).to have_content("Rabbit")
        expect(page).to have_content("Displaying 1 person")
      end
    end

    context "with a partial given name filter" do
      it "responds with a filtered list of people" do
        fill_in "Family or Given Name", with: "oger"
        click_on "Filter"

        expect(page).to have_content("Rabbit")
        expect(page).to have_content("Displaying 1 person")
      end
    end
  end
end
