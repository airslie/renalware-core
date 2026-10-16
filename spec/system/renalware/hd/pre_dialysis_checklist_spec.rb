RSpec.describe "HD session pre dialysis checklist", :js do
  let(:nurse) { create(:user, role: "clinical") }
  let(:patient) { create(:hd_patient, :with_hd_modality) }
  let(:checklist_label) { "Have you gone through the Pre Dialysis Check list with the patient?" }
  let(:findings_label) { "Significant findings / reason not completed" }

  before do
    create(:hd_session, patient:, by: nurse)
    login_as nurse
  end

  def edit_open_session
    visit patient_hd_dashboard_path(patient)
    within "article.hd-sessions" do
      click_on I18n.t("open", scope: "renalware.hd.sessions_types.edit")
    end
  end

  def sign_off
    page.first("input[name='signoff']").click
  end

  context "when the pre dialysis checklist is required" do
    before do
      allow(Renalware.config)
        .to receive(:hd_sessions_require_pre_dialysis_checklist)
        .and_return(true)
    end

    it "shows the checklist fields with no option selected" do
      edit_open_session

      expect(page).to have_text(checklist_label)
      expect(page).to have_field(findings_label)
      expect(page).to have_unchecked_field("Yes", name: /pre_dialysis_checklist\]\[completed/)
      expect(page).to have_unchecked_field("No", name: /pre_dialysis_checklist\]\[completed/)
    end

    it "requires an answer and then findings when the answer is no" do
      edit_open_session
      sign_off

      expect(page).to have_text(checklist_label)
      expect(page).to have_text("can't be blank")

      choose "No", name: /pre_dialysis_checklist\]\[completed/
      sign_off

      expect(page).to have_text(findings_label)
      expect(page).to have_text("can't be blank")
    end
  end

  context "when the pre dialysis checklist is not required" do
    before do
      allow(Renalware.config)
        .to receive(:hd_sessions_require_pre_dialysis_checklist)
        .and_return(false)
    end

    it "does not show the checklist fields" do
      edit_open_session

      expect(page).to have_no_text(checklist_label)
      expect(page).to have_no_field(findings_label)
    end
  end
end
