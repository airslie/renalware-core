require "rails_helper"

RSpec.describe "Changing a patient's GP (primary care physician)", type: :request do
  let(:patient) { create(:patient) }
  let(:primary_care_physician) { create(:primary_care_physician) }

  describe "GET edit" do
    it "responds with a form" do
      get edit_patient_primary_care_physician_path(patient)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = { patient: { primary_care_physician_id: primary_care_physician.id } }

        patch patient_primary_care_physician_path(patient), params: attributes

        expect(response).to have_http_status(:redirect)

        follow_redirect!

        expect(response).to have_http_status(:success)
        expect(patient.reload.primary_care_physician).to eq(primary_care_physician)
      end
    end
  end
end
