# frozen_string_literal: true

require "rails_helper"

RSpec.describe "View a patient's BioBank samples" do
  include ::HeroicHelpers

  let(:study) { create(:heroic_research_study) }

  context "when the patient has a DNA sasmple" do
    it "displays the sample in a table" do
      user = login_as_clinical
      make_user_an_investigator(user: user)
      received_at = Time.zone.now - 1.day
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

      expect(page).to have_content("Samples")

      within "table.bio-bank-samples tbody" do
        expect(page).to have_content("DNA")
        expect(page).to have_content(I18n.l(received_at))
        expect(page).to have_content(I18n.l(processed_at))
        expect(page).to have_content(sample.storage_location)
        expect(page).not_to have_content("Aliquots")
      end
    end
  end
end
