require "rails_helper"

RSpec.describe "AKI alert management", type: :request do
  let(:user) { @current_user }
  let(:patient) { create(:renal_patient, by: user) }

  describe "GET index" do
    it "renders a list of AKI Alerts" do
      create(
        :aki_alert,
        notes: "abc",
        patient: patient,
        action: create(:aki_alert_action, name: "action1"),
        by: user
      )
      get renal_aki_alerts_path

      expect(response).to have_http_status(:success)
      expect(response.body).to match(patient.to_s)
      expect(response.body).to match("action1")
    end
  end

  describe "GET edit" do
    it "renders the edit form" do
      alert = create(:aki_alert, notes: "abc", patient: patient, by: user)
      get edit_renal_aki_alert_path(alert, format: :html)
    end
  end

  describe "PATCH update" do
    context "with valid params" do
      it "update the alert" do
        action1 = create(:aki_alert_action, name: "action1")
        action2 = create(:aki_alert_action, name: "action2")
        alert = create(
          :aki_alert,
          notes: "abc",
          patient: patient,
          action: action1,
          hotlist: false,
          by: user
        )
        attributes = {
          notes: "xyz",
          action_id: action2.id,
          hotlist: true
        }

        patch renal_aki_alert_path(alert), params: { renal_aki_alert: attributes }

        follow_redirect!

        expect(response).to have_http_status(:success)
        alert.reload
        expect(alert.notes).to eq("xyz")
        expect(alert.action_id).to eq(action2.id)
        expect(alert.hotlist?).to be_truthy
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
