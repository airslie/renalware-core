# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Import a bio bank feed" do
  it "creates relevant samples and aliquots" do
    user = login_as_clinical
    study = create(:heroic_research_study, by: user)
    create(:research_investigatorship, user: user, study: study, by: user)

    visit research.study_path(study)

    click_on "Upload samples"

    expect(page).to have_current_path(heroic.new_bio_bank_sample_upload_path)
  end
end
