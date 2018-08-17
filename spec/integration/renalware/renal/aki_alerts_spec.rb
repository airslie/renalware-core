# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AKI alert management", type: :request do
  let(:user) { @current_user }
  let(:patient) { create(:renal_patient, by: user) }
  let(:hospital_ward) { create(:hospital_ward) }

  describe "GET index" do
    before do
      create(
        :aki_alert,
        notes: "abc",
        patient: patient,
        hospital_ward: hospital_ward,
        max_aki: 1,
        aki_date: Time.zone.today,
        action: create(:aki_alert_action, name: "today"),
        by: create(:user, family_name: "Patient1"),
        created_at: Time.zone.now
      )
      create(
        :aki_alert,
        notes: "abc",
        patient: patient,
        hospital_ward: hospital_ward,
        max_aki: 2,
        aki_date: Time.zone.today - 1.day,
        action: create(:aki_alert_action, name: "yesterday"),
        by: create(:user, family_name: "Patient2"),
        created_at: Time.zone.now - 1.day
      )
    end

    describe "with no filters" do
      it "renders a list of AKI Alerts" do
        get renal_aki_alerts_path

        expect(response).to have_http_status(:success)
        expect(response.body).to match("today")
        expect(response.body).to match("Patient1")
        expect(response.body).to match(I18n.l(Time.zone.today))

        expect(response.body).to match("yesterday")
        expect(response.body).to match("Patient1")
        expect(response.body).to match(I18n.l(Time.zone.today - 1 .day))
        expect(response.body).to match(hospital_ward.name)
      end
    end

    describe "filtering by date" do
      it "renders a list of just today's AKI Alerts" do
        get renal_aki_alerts_path(q: { date: I18n.l(Time.zone.today) })

        expect(response).to have_http_status(:success)
        expect(response.body).to match("Patient1")
        expect(response.body).not_to match("Patient2")
      end
    end

    describe "filtered by hotlist" do
      it "renders a list of all AKI Alerts with hotlist=true" do
        action1 = create(:aki_alert_action, name: "action1")
        action2 = create(:aki_alert_action, name: "action2")
        create(
          :aki_alert,
          notes: "abc",
          patient: create(:renal_patient, family_name: "NOTHOT", by: user),
          hotlist: false,
          action: action1,
          max_cre: 100,
          cre_date: "2018-01-01",
          max_aki: 2,
          aki_date: "2018-02-01",
          hospital_ward: nil,
          by: user
        )

        create(
          :aki_alert,
          notes: "abc",
          patient: create(:renal_patient, family_name: "HOT", by: user),
          hotlist: true,
          max_cre: 100,
          action: action2,
          cre_date: "2018-01-01",
          max_aki: 2,
          aki_date: "2018-02-01",
          hospital_ward: nil,
          by: user
        )
        get renal_aki_alerts_path(q: { on_hotlist: true })

        expect(response).to have_http_status(:success)
        expect(response.body).to match("HOT")
        expect(response.body).not_to match("NOTHOT")
      end

      context "when a Print version requested" do
        it "renders a PDF" do
          get renal_aki_alerts_path(q: { on_hotlist: true }, format: :pdf)

          expect(response).to be_success
          expect(response["Content-Type"]).to eq("application/pdf")
          expect(response["Content-Disposition"]).to include("inline")
          filename = "AKI Alerts #{I18n.l(Time.zone.today)}.pdf"
          expect(response["Content-Disposition"]).to include(filename)
        end
      end
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
