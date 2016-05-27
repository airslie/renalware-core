require "rails_helper"

RSpec.describe "User's Dashboard", type: :request do
  before { create_letters }

  describe "GET show" do
    it "responds with the dashboard page" do
      get dashboard_path

      expect(response).to have_http_status(:success)
    end
  end

  def create_letters
    patient = build(:letter_patient)
    recipient = build(:letter_recipient, :main, person_role: "patient")
    create(:draft_letter, patient: patient, author: @current_user, main_recipient: recipient)

    recipient = build(:letter_recipient, :main, person_role: "patient")
    create(:typed_letter, patient: patient, author: @current_user, main_recipient: recipient)
  end
end
