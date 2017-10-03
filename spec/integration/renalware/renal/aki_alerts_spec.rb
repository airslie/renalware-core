require "rails_helper"

RSpec.describe "AKI alert management", type: :request do
  let(:user) { @current_user }
  let(:patient) { create(:renal_patient, by: user) }

  describe "GET index" do
    it "renders a list of AKI Alerts" do
      create(:aki_alert, notes: "abc", patient: patient)
      get renal_aki_alerts_path

      expect(response).to have_http_status(:success)
      expect(response.body).to match(patient.to_s)
    end
  end

  describe "GET edit" do
    it "renders the edit form" do
      alert = create(:aki_alert, notes: "abc", patient: patient)
      get edit_renal_aki_alert_path(alert, format: :html)
    end
  end

  describe "PATCH update" do
    context "with valid params" do
      it "update the alert" do
        alert = create(:aki_alert, notes: "abc", patient: patient)
        attributes = { notes: "xyz" }

        patch renal_aki_alert_path(alert), params: { renal_aki_alert: attributes }

        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(alert.reload.notes).to eq("xyz")
      end
    end

    # nothing avail yet on the model to prompt an validation error..
    #
    # context "with invalid params" do
    #   it "re-renders the edit form" do
    #     alert = create(:aki_alert, notes: "abc", patient: patient)
    #     attributes = { patient_id: nil, notes: "xyz" }
    #     patch renal_aki_alert_path(alert), params: { renal_aki_alert: attributes }

    #     follow_redirect!
    #     expect(response).to have_http_status(:success)
    #     expect(alert.reload.notes).to eq("abc")
    #   end
    # end
  end
end
