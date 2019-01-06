# frozen_string_literal: true

require "rails_helper"

describe "HD Summary (Dashboard)", type: :request do
  let(:patient) { create(:hd_patient) }
  let(:user) { create(:user) }

  describe "GET" do
    it "renders the HD Summary" do
      get patient_hd_dashboard_path(patient)

      expect(response).to be_successful
    end
  end
end
