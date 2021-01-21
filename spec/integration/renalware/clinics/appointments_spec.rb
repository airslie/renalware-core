# frozen_string_literal: true

require "rails_helper"

describe "Appointments", type: :request do
  describe "GET index" do
    it "responds with a list of appointments" do
      user = login_as_clinical
      consultant = create(:renal_consultant)
      patient = Renalware::Clinics.cast_patient(create(:patient, by: user))
      create(
        :appointment,
        patient: patient,
        clinic: create(:clinic),
        consultant: consultant,
        starts_at: Time.zone.now,
        by: user
      )

      get appointments_path

      expect(response).to be_successful
      expect(response.body).to include(patient.to_s)
      expect(response.body).to include(consultant.to_s)
    end
  end
end
