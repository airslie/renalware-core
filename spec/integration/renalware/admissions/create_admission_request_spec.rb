require "rails_helper"

feature "Create an Admission Request", type: :feature, js: true do
  scenario "Creating a new request from the patient LH menu" do
    login_as_clinician
    patient = create(:patient)
    reason = create(:admissions_request_reason, description: "AKI")
    clinical_profile_path = patient_clinical_profile_path(patient)
    dialog_title = "Request Admission"

    visit clinical_profile_path

    within ".side-nav" do
      click_on "Request admission"
    end

    # We have just raised a modal, but are on the same page
    expect(page.current_path).to eq(clinical_profile_path)

    expect(page).to have_content(dialog_title)

    # 2. Try filling out without a reason and we should get an error displayed in the dialog

    click_on("Create")
    expect(page).to have_content(t_validation(:reason_id, :blank))

    # 2. Now submit valid data and we should be able to submit
    select reason.description, from: "Reason"
    click_on("Create")

    expect(page).to have_content(dialog_title)
  end

  def t_validation(attribute, validation)
    I18n.t(
      validation,
      scope: "activerecord.errors.models.renalware/admissions/request.#{attribute}"
    )
  end
end
