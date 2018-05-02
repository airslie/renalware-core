# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Patient's Protocol PDF", type: :request do
  include PathologySpecHelper
  let(:user) { create(:user) }
  let(:patient) do
    create(:hd_patient, family_name: "Rabbit", local_patient_id: "KCH12345", by: user)
  end

  describe "GET show" do
    it "responds with an inlined PDF by default" do
      # TODO: stub out patient.current_observation_set so we don't need to create these descs?
      create_descriptions(%w(HGB PLT))
      get patient_hd_protocol_path(patient_id: patient)

      expect(response).to have_http_status(:success)
      expect(response).to be_success
      expect(response["Content-Type"]).to eq("application/pdf")
      expect(response["Content-Disposition"]).to include("inline")
    end

    it "can responds with a PDF download" do
      # TODO: stub out patient.current_observation_set so we don't need to create these descs?
      create_descriptions(%w(HGB PLT))
      get patient_hd_protocol_path(patient_id: patient, disposition: :attachment)

      expect(response).to be_success
      expect(response["Content-Type"]).to eq("application/pdf")
      filename = "RABBIT-KCH12345-PROTOCOL.pdf"
      expect(response["Content-Disposition"]).to include("attachment")
      expect(response["Content-Disposition"]).to include(filename)
    end

    describe "Virology" do
      context "when the patient has no HIV, HepB or HepC" do
        it "displays no Virology info" do
          get patient_hd_protocol_path(patient_id: patient, disposition: :attachment)

          expect(response).to have_http_status(:success)
          expect(response.body).not_to include("HIV")
          expect(response.body).not_to include("Hepatitis B")
          expect(response.body).not_to include("Hepatitis C")
        end
      end

      context "when the patient has HIV" do
        before do
          patient.document.hiv.status = :yes
          patient.document.hiv.confirmed_on_year = 2001
          patient.save_by!(user)
        end

        it "displays just the HIV result" do
          get patient_hd_dashboard_path(patient)

          expect(response).to have_http_status(:success)
          expect(response.body).to include("HIV")
          expect(response.body).to include("Yes (2001")
          expect(response.body).not_to include("Hepatitis B")
          expect(response.body).not_to include("Hepatitis C")
        end
      end
    end
  end
end
