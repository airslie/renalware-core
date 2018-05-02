# frozen_string_literal: true

require "rails_helper"

RSpec.describe "HD Summary (Dashboard)", type: :request do
  let(:patient) { create(:hd_patient) }
  let(:user) { create(:user) }

  describe "GET" do
    it "renders the HD Summary" do
      get patient_hd_dashboard_path(patient)

      expect(response).to have_http_status(:success)
    end

    context "when the patient has no HIV, HepB or HEPC in their clinical profile" do
      it "displays an empty Virology section" do
        get patient_hd_dashboard_path(patient)

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Virology")
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

      it "displays an empty Virology section" do
        get patient_hd_dashboard_path(patient)

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Virology")
        expect(response.body).to include("HIV")
        expect(response.body).not_to include("Hepatitis B")
        expect(response.body).not_to include("Hepatitis C")
      end
    end
  end
end
