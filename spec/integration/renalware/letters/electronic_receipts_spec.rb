require "rails_helper"

RSpec.describe "View a user's read/unread electronic ccs", type: :request do
  include LettersSpecHelper

  before(:all) do
    @primary_care_physician = create(:letter_primary_care_physician)
    @other_user = create(:user)
  end

  after(:all) do
    @primary_care_physician.destroy!
    @other_user.destroy!
  end

  def create_receipt(patient_family_name, body, read: false, to: @current_user)
    patient = create(
      :letter_patient,
      primary_care_physician: @primary_care_physician,
      family_name: patient_family_name
    )
    approved_letter = create_letter(
      to: :patient,
      state: :approved,
      patient: patient,
      description: "xxx",
      body: body
    )
    create(
      :letter_electronic_receipt,
      letter: approved_letter,
      recipient: to,
      read_at: read ? Time.zone.now : nil
    )
  end

  describe "GET unread" do
    it "responds successfully" do
      body = SecureRandom.hex(10)
      create_receipt("GRAVES", body, read: false, to: @current_user)
      create_receipt("GRAVES", "This one is not for my eyes", read: false, to: @other_user)

      get unread_letters_electronic_receipts_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:unread)
      expect(response.body).to include("GRAVES")
      expect(response.body).to include(body)
      expect(response.body).not_to include("This one is not for my eyes")
    end
  end

  describe "GET read" do
    it "responds successfully" do
      get read_letters_electronic_receipts_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:read)
    end
  end

  describe "GET sent" do
    it "responds successfully" do
      get sent_letters_electronic_receipts_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:sent)
    end
  end
end
