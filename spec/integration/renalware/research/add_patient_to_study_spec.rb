# This is feature spec (rather than adding to the existing request specs)
# as adding a patient uses a modal (js)
require "rails_helper"

feature "Managing studies", type: :feature, js: true do
  include AjaxHelpers

  scenario "Adding a patient to a research study" do
    pending "Can't work out how to do select from select2 ajax search atm"
    patient = create(:patient, family_name: "XX")
    study = create_study

    login_as_read_write
    visit research_study_participants_path(study)

    click_on "Add"

    within ".modal" do
      select2 patient.to_s(:long), from: "Patient"
      click_on "Add"
    end

    expect(page).to have_content("XX")
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
