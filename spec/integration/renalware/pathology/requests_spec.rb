# frozen_string_literal: true

require "rails_helper"

describe "Configuring Requests", type: :request do
  describe "GET index" do
    it "responds with a list of request forms" do
      create(
        :pathology_requests_request,
        clinic: create(:clinic),
        patient: create(:pathology_patient),
        consultant: create(:renal_consultant)
      )
      create(
        :pathology_requests_request,
        clinic: create(:clinic),
        patient: create(:pathology_patient),
        consultant: create(:renal_consultant)
      )

      get pathology_requests_requests_path

      expect(response).to be_successful
    end
  end

  describe "GET show" do
    it "responds with a list of request forms" do
      request = create(
        :pathology_requests_request,
        clinic: create(:clinic),
        patient: create(:pathology_patient),
        consultant: create(:renal_consultant)
      )

      get pathology_requests_request_path(id: request.id, format: "pdf")

      expect(response).to be_successful
      expect(response.headers["Content-Type"]).to eq("application/pdf")
    end
  end
end
