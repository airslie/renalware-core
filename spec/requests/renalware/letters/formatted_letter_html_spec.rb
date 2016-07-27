require "rails_helper"

RSpec.describe "Get formatted letter HTML content", type: :request do
  include LettersSpecHelper

  context "with a draft letter" do
    let(:letter) { create_draft_letter }

    describe "GET show" do
      it "responds with the HTML" do
        get patient_letters_letter_formatted_path(patient_id: letter.patient, letter_id: letter)
        expect(response).to be_success
        expect(response.body).to include(letter.patient.full_name)
      end
    end
  end

  context "with an archived letter" do
    let(:letter) { create_archived_letter }

    describe "GET show" do
      it "responds with the HTML" do
        get patient_letters_letter_formatted_path(patient_id: letter.patient, letter_id: letter)
        expect(response).to be_success
        expect(response.body).to eq(letter.content)
      end
    end
  end

  def create_draft_letter
    doctor = create(:letter_doctor)
    patient = create(:letter_patient, doctor: doctor)

    create_letter(to: :patient, patient: patient)
  end

  def create_archived_letter
    archive_letter(create_draft_letter)
  end

  def archive_letter(letter)
    archived_letter = letter.becomes!(Renalware::Letters::Letter::Typed).archive(by: create(:user))
    archived_letter.save!
    archived_letter
  end
end
