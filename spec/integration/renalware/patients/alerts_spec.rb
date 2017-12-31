require "rails_helper"

RSpec.describe "Managing alerts", type: :request do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new alert" do
        headers = {
          "HTTP_REFERER" => "/",
          "ACCEPT" => "application/javascript"
        }
        params = {
          patients_alert: {
            urgent: true,
            notes: "An alert"
          }
        }

        post(patient_alerts_path(patient), params: params, headers: headers)
        expect(response).to have_http_status(:success)

        alert = Renalware::Patients::Alert.find_by(patient_id: patient.id)

        expect(alert).not_to be_nil
        expect(alert.urgent).to be_truthy
        expect(alert.notes).to eq("An alert")
      end
    end

    context "with invalid attributes" do
      it "returns 44 validation error and does not create a new alert" do
        headers = {
          "HTTP_REFERER" => "/",
          "ACCEPT" => "application/javascript"
        }
        params = {
          patients_alert: {
            urgent: true,
            notes: ""
          }
        }

        post(patient_alerts_path(patient), params: params, headers: headers)

        expect(response).to have_http_status(422)
        alert = Renalware::Patients::Alert.find_by(patient_id: patient.id)
        expect(alert).to be_nil
      end
    end
  end

  describe "DELETE destroy" do
    let(:alert) do
      create(:patient_alert,
             patient: patient,
             by: Renalware::Patients.cast_user(user))
    end

    it "soft deletes the alert" do
      headers = {
        "HTTP_REFERER" => "/",
        "ACCEPT" => "application/javascript"
      }

      delete patient_alert_path(patient, alert), headers: headers

      expect(response).to have_http_status(:success)
      expect(Renalware::Patients::Alert).not_to exist(id: alert.id)
    end

    it "does not baulk if the alert has already been deleted" do
      alert.destroy!
      expect(Renalware::Patients::Alert).not_to exist(id: alert.id)
      headers = {
        "HTTP_REFERER" => "/",
        "ACCEPT" => "application/javascript"
      }

      delete patient_alert_path(patient, alert), headers: headers

      expect(response).to have_http_status(:success)
      expect(Renalware::Patients::Alert).not_to exist(id: alert.id)

      # Check the alert is still available in the #undeleted scope
      expect(Renalware::Patients::Alert.count).to eq(0)
      expect(Renalware::Patients::Alert.with_deleted.count).to eq(1)
    end
  end
end
