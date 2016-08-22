require "rails_helper"

RSpec.describe "Get formatted letter HTML content", type: :request do
  include LettersSpecHelper

  let(:doctor) { create(:letter_doctor) }
  let(:patient) { create(:letter_patient, doctor: doctor) }

  context "with a draft letter" do
    let(:letter) { create_draft_letter(patient) }

    describe "GET show" do
      let(:patient) {
        create(:letter_patient, doctor: doctor,
          family_name: "RABBIT",
          local_patient_id: "KCH57837"
        )
      }

      it "responds with the HTML" do
        get patient_letters_letter_formatted_path(patient_id: letter.patient, letter_id: letter)
        expect(response).to be_success
        expect(response.body).to include(letter.patient.full_name)
      end

      it "responds with a PDF" do
        get patient_letters_letter_formatted_path(
          patient_id: letter.patient, letter_id: letter, format: "pdf"
        )

        expect(response).to be_success
        expect(response["Content-Type"]).to eq("application/pdf")
        filename = "RABBIT-KCH57837-#{letter.id}-DRAFT".upcase
        expect(response["Content-Disposition"]).to include(filename)
      end
    end
  end

  context "with an archived letter" do
    let(:letter) { create_archived_letter(patient) }

    describe "GET show" do
      it "responds with the HTML" do
        get patient_letters_letter_formatted_path(patient_id: letter.patient, letter_id: letter)
        expect(response).to be_success
        expect(response.body).to include(letter.content)
      end
    end
  end

  def create_draft_letter(patient)
    create_letter(to: :patient, patient: patient)
  end

  def create_archived_letter(patient)
    draft = create_draft_letter(patient)
    archive_letter(draft)
  end

  def archive_letter(letter)
    archived_letter = letter.becomes!(Renalware::Letters::Letter::PendingReview).archive(by: create(:user))
    archived_letter.save!
    archived_letter
  end
end
