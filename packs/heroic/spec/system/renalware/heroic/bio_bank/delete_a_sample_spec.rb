# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Delete a sample" do
  include HeroicHelpers

  let(:study) { create(:heroic_research_study) }
  let(:patient) { create(:patient) }

  it "allows deleting a sample" do
    user = login_as_super_admin
    serum = create(:bio_bank_sample, :serum, by: user, patient: patient)
    create(:bio_bank_aliquot, sample: serum, by: user)

    visit heroic.bio_bank_patient_samples_path(patient)

    within "table.bio-bank-samples" do
      click_on "Delete"
    end

    expect(page).to have_current_path(heroic.bio_bank_patient_samples_path(patient))
    expect(Renalware::Heroic::BioBank::Sample.count).to eq(0)
    expect(Renalware::Heroic::BioBank::Aliquot.count).to eq(0)
  end
end
