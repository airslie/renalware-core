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
      get patient_hd_protocol_path(patient_id: patient)

      expect(response).to be_successful
      expect(response["Content-Type"]).to eq("application/pdf")
      expect(response["Content-Disposition"]).to include("inline")
    end

    it "can responds with a PDF download" do
      get patient_hd_protocol_path(patient_id: patient, disposition: :attachment)

      expect(response).to be_successful
      expect(response["Content-Type"]).to eq("application/pdf")
      filename = "RABBIT-KCH12345-PROTOCOL.pdf"
      expect(response["Content-Disposition"]).to include("attachment")
      expect(response["Content-Disposition"]).to include(filename)
    end

    describe "Recent pathology" do
      it "displays latest HGB PLT CRP values" do
        # Pass debug=1 so we get back html rather than pdf (see pdf options in protocols controller)
        get patient_hd_protocol_path(patient_id: patient, debug: 1)

        expect(response).to be_successful
        expect(response.body).to include("PLT")
        expect(response.body).to include("CRP")
        expect(response.body).to include("HGB")

        # TODO: To test the actual values we would need to parse the template.
        # We could make this test a type: :feature
      end
    end

    describe "Virology" do
      context "when the patient has no HIV, HepB or HepC" do
        it "displays no Virology info" do
          # Pass debug=1 in order to render html not pdf
          get patient_hd_protocol_path(patient_id: patient, disposition: :attachment, debug: 1)

          expect(response).to be_successful
          expect(response.body).not_to include("HIV")
          expect(response.body).not_to include("Hepatitis B")
          expect(response.body).not_to include("Hepatitis C")
        end
      end

      context "when the patient is HIV+" do
        before do
          virology_patient = Renalware::Virology.cast_patient(patient)
          profile = virology_patient.profile || virology_patient.build_profile
          profile.document.hiv.status = :yes
          profile.document.hiv.confirmed_on_year = 2001
          profile.save!
        end

        it "displays just the HIV result" do
          get patient_hd_dashboard_path(patient)

          expect(response).to be_successful
          expect(response.body).to include("HIV")
          expect(response.body).to include("Yes (2001")
          expect(response.body).not_to include("Hepatitis B")
          expect(response.body).not_to include("Hepatitis C")
        end
      end
    end
  end
end
