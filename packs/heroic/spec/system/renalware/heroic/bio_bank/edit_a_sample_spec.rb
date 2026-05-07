# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editing a sample" do
  include ::HeroicHelpers

  let(:study) { create(:heroic_research_study) }

  it do
    user = login_as_clinical
    make_user_an_investigator(user: user)
    time = Time.zone.now
    patient = create(:patient, by: user)
    sample = create(
      :bio_bank_sample,
      :dna,
      patient: patient,
      by: user
    )

    visit heroic.bio_bank_patient_samples_path(patient)

    within "table.bio-bank-samples tbody tr" do
      click_on "Edit"
    end

    # Sample type not editable
    expect(page).not_to have_css("#sample_sample_type")
    fill_in "Received at", with: I18n.l(time)
    fill_in "Collected at", with: I18n.l(time)
    fill_in "Processed at", with: I18n.l(time)
    fill_in "Notes", with: "123"
    click_on "Save"

    expect(page).to have_current_path(heroic.bio_bank_patient_samples_path(patient))

    sample.reload
    time_with_sec_usec = time.change(usec: 0, sec: 0)
    expect(sample.received_at).to eq(time_with_sec_usec)
    expect(sample.collected_at).to eq(time_with_sec_usec)
    expect(sample.processed_at).to eq(time_with_sec_usec)
    expect(sample.notes).to eq("123")
  end
end
