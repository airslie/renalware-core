# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Adding an aliquot to a Serum sample" do
  include HeroicHelpers

  let(:study) { create(:heroic_research_study) }

  context "when the patient has a Serum sample" do
    it "allows adding an aliquote to the sample" do
      user = login_as_clinical
      make_user_an_investigator(user: user)
      serum = create(:bio_bank_sample, :serum, by: user)

      visit heroic.bio_bank_patient_samples_path(serum.patient)

      within "table.bio-bank-samples tbody" do
        expect(page).to have_text("Serum")
        # click_on "Aliquots"
      end

      # expect(page).to have_current_path(heroic.bio_bank_sample_aliquots_path(serum))
      # expect(page).to have_content "Aliquots"

      # could add to bottom of table here

      # within ".page-actions" do
      #   click_on "Add"
      # end

      # expect(page).to have_current_path(heroic.new_bio_bank_sample_aliquot_path(serum))
    end
  end
end
