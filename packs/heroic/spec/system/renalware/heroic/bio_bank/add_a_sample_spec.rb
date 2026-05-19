# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manually adding a sample to a patient" do
  include HeroicHelpers

  let(:study) { create(:heroic_research_study) }

  it "allows adding a sample" do
    user = login_as_clinical
    make_user_an_investigator(user: user)
    patient = create(:patient, by: user)

    create(:serum_sample_type)
    time = Time.zone.now

    visit heroic.bio_bank_patient_samples_path(patient)

    within ".page-actions" do
      click_on "Add"
    end

    select "Serum", from: "Sample type"
    fill_in "Collected at", with: I18n.l(time)
    fill_in "Received at", with: I18n.l(time)
    fill_in "Processed at", with: I18n.l(time)
    fill_in "Storage location", with: "Location1"
    fill_in "Notes", with: "Loreum ipsum delor"
    click_on "Save"

    sample = Renalware::Heroic::BioBank::Sample.where(patient: patient).last
    time = time.change(usec: 0, sec: 0)
    expect(sample).to have_attributes(
      collected_at: time,
      received_at: time,
      processed_at: time,
      storage_location: "Location1",
      notes: "Loreum ipsum delor"
    )
  end
end
