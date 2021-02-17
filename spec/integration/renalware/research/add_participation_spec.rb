# frozen_string_literal: true

require "rails_helper"

describe "Add a patient to a study (creating a participation)", type: :system, js: true do
  include AjaxHelpers

  it "Adding a patient to a research study" do
    patient = create(:patient, family_name: "XXX", given_name: "Jon")
    study = create_study

    login_as_clinical
    visit research_study_participants_path(study)

    click_on t("btn.add")

    expect(page).to have_current_path(new_research_study_participant_path(study))
    select2(patient.to_s(:long), css: "#patient-select2", search: true)

    fill_in "Joined on", with: "2019-01-01"
    click_on t("btn.save")

    expect(page).to have_current_path(research_study_participants_path(study))
    expect(page).to have_content(patient.to_s)
  end

  def create_study
    create(
      :research_study,
      code: "Study1",
      description: "Study 1",
      leader: "Jack Jones"
    )
  end
end
