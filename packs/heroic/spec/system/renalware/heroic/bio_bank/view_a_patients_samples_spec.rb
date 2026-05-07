# frozen_string_literal: true

require "rails_helper"

RSpec.describe "View a patient's BioBank samples" do
  include HeroicHelpers

  let(:study) { create(:heroic_research_study) }

  context "when the patient has a DNA sasmple" do
    it "displays the sample in a table" do
      user = login_as_clinical
      make_user_an_investigator(user: user)
      received_at = 1.day.ago
      processed_at = Time.zone.now
      patient = create(:patient, by: user)
      sample = create(
        :bio_bank_sample,
        :dna,
        patient: patient,
        by: user,
        received_at: received_at,
        processed_at: processed_at,
        storage_location: "Location1"
      )

      visit heroic.bio_bank_patient_samples_path(patient)

      expect(page).to have_text("Samples")

      within "table.bio-bank-samples tbody" do
        expect(page).to have_text("DNA")
        expect(page).to have_text(I18n.l(received_at))
        expect(page).to have_text(I18n.l(processed_at))
        expect(page).to have_text(sample.storage_location)
        expect(page).to have_no_text("Aliquots")
      end
    end
  end
end
