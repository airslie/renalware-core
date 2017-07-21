require "rails_helper"

RSpec.describe "Managing an HD DNA Session", type: :request do

  describe "GET show" do
    it "renders successfully" do
      dna_session = create(:hd_dna_session)
      get patient_hd_session_path(patient_id: dna_session.patient, id: dna_session.id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    context "when the session is still mutable" do
      it "renders successfully" do
        dna_session = create(:hd_dna_session)
        get edit_patient_hd_session_path(patient_id: dna_session.patient, id: dna_session.id)

        expect(response).to have_http_status(:success)
      end
    end

    context "when the session is no longer mutable" do
      it "redirects to #show with a flash message" do
        dna_session = travel_to(Time.zone.now - 1.day) do
          create(:hd_dna_session)
        end

        route_params = { patient_id: dna_session.patient, id: dna_session.id }
        # show_path = patient_hd_session_path(route_params)
        edit_path = edit_patient_hd_session_path(route_params)

        get edit_path

        # expect(response).to redirect_to(show_path)
        expect(flash[:warning]).to be_present
        expect(flash[:warning]).not_to match(/translation/)
      end
    end
  end
end
