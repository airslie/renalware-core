# Until it is archived, a letter can be deleted.

RSpec.describe "Deleting a letter", :js do
  let(:doctor) { create(:user, :clinical) }
  let(:other_doctor) { create(:user, :clinical) }
  let(:patient) { letter.patient }

  context "when letter is pending review" do
    let(:letter) { create(:pending_review_letter, by: doctor) }

    it "is deleted by the author" do
      login_as doctor
      visit patient_letters_letters_path(patient)

      expect(page).to have_content "Pending Review"
      accept_alert { click_on t("btn.delete") }
      expect(page).to have_content "Letters"
      expect(page).to have_no_content "Pending Review"
      expect(Renalware::Letters::Letter.with_deleted.count).to eq(0)
    end

    context "when logged in as someone else" do
      it "cannot be deleted" do
        login_as other_doctor
        visit patient_letters_letters_path(patient)

        expect(page).to have_content "Pending Review"
        expect(page).to have_no_button t("btn.delete")
      end
    end
  end

  context "when letter is approved" do
    let(:letter) { create(:approved_letter, by: doctor) }

    it "cannot be deleted" do
      login_as doctor
      visit patient_letters_letters_path(patient)

      expect(page).to have_content "Approved"
      expect(page).to have_no_button t("btn.delete")
    end
  end
end
