require "rails_helper"

RSpec.describe "User's Dashboard", type: :request do
  let(:patients_user) { Renalware::Patients.cast_user(@current_user) }
  let!(:bookmark) { create(:patients_bookmark, user: patients_user) }

  before { create_letters }

  describe "GET show" do
    it "responds with the dashboard page" do
      get dashboard_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(bookmark.patient.full_name)
    end
  end

  # TODO: Re-write this using Rspec 3 style and add expectations to check the letters are displayed
  def create_letters
    patient = build(:letter_patient)
    recipient = build(:letter_recipient, :main, person_role: "patient")
    create(:draft_letter, patient: patient, author: @current_user, main_recipient: recipient)

    recipient = build(:letter_recipient, :main, person_role: "patient")
    create(:typed_letter, patient: patient, author: @current_user, main_recipient: recipient)
  end
end
