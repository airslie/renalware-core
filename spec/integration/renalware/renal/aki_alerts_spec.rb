# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AKI alert management", type: :request do
  let(:user) { @current_user }
  let(:patient) { create(:renal_patient, by: user) }
  let(:hospital_ward) { create(:hospital_ward) }

  describe "GET index" do
    it "renders a list of AKI Alerts" do
      create(
        :aki_alert,
        notes: "abc",
        patient: patient,
        hospital_ward: hospital_ward,
        max_cre: 99,
        cre_date: "2018-01-01",
        max_aki: 2,
        aki_date: "2018-02-01",
        action: create(:aki_alert_action, name: "action1"),
        by: create(:user, family_name: "Fink")
      )
      get renal_aki_alerts_path

      expect(response).to have_http_status(:success)
      expect(response.body).to match(patient.to_s)
      expect(response.body).to match("action1")
      expect(response.body).to match("01-Jan-2018")
      expect(response.body).to match("01-Feb-2018")
      expect(response.body).to match("99")
      expect(response.body).to match("2")
      expect(response.body).to match("Fink")
      expect(response.body).to match(hospital_ward.name)
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
          max_cre: 100,
          cre_date: "2018-01-01",
          max_aki: 2,
          aki_date: "2018-02-01",
          hospital_ward: nil,
          by: user
        )
        attributes = {
          notes: "xyz",
          action_id: action2.id,
          hotlist: true,
          hospital_ward_id: hospital_ward.id
        }

        patch renal_aki_alert_path(alert), params: { renal_aki_alert: attributes }

        follow_redirect!

        expect(response).to have_http_status(:success)
        alert.reload
        expect(alert.notes).to eq("xyz")
        expect(alert.action_id).to eq(action2.id)
        expect(alert).to be_hotlist
        expect(alert).to have_attributes(
          max_cre: 100,
          cre_date: Date.parse("01-Jan-2018"),
          max_aki: 2,
          aki_date: Date.parse("01-Feb-2018")
        )
        expect(alert.hospital_ward).to eq(hospital_ward)
      end
    end
  end
end
