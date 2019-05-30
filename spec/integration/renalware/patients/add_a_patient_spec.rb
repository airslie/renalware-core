# frozen_string_literal: true

require "rails_helper"

# This test currently targets a dummy patient/abridgements path so we can simulate
# a user searching for a patient in the master index, At some point that functionality will be moved
# to patients/new and this test will need updating.
describe "A user adds a patient", type: :system do
  describe "displaying search results that match user-entered criteria" do
    context "when an abridged patient exists in the master index" do
      it "displays the abridged patient" do
        login_as_clinical
        create(
          :abridged_patient,
          hospital_number: "KCH123",
          given_name: "John",
          family_name: "SMITH",
          born_on: "1967-01-01"
        )

        visit patients_abridgements_path

        fill_in "Search by hospital number or name", with: "KCH123"
        click_on "Search"

        expect(page).to have_content("SMITH, John")
      end

      context "when another unmatching abridged patient exists with same DOB" do
        let(:dob) { "1967-01-01" }

        it "displays the second patient under 'Patients matching by DOB' heading" do
          login_as_clinical
          create(
            :abridged_patient,
            hospital_number: "KCH123",
            given_name: "John",
            family_name: "SMITH",
            born_on: dob
          )
          create(
            :abridged_patient,
            hospital_number: "KCH456",
            given_name: "Jake",
            family_name: "OTHER",
            born_on: dob
          )
          create(:abridged_patient, family_name: "NOMATCH")

          visit patients_abridgements_path

          fill_in "Search by hospital number or name", with: "KCH123"
          click_on "Search"

          within(".search-results") do
            expect(page).to have_content("SMITH, John")
          end

          within(".search-results--by-dob") do
            expect(page).to have_content("OTHER, Jake")
            expect(page).not_to have_content("SMITH, John")
          end

          expect(page).not_to have_content("NOMATCH")
        end
      end
    end
  end
end
