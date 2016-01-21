require "rails_helper"

RSpec.describe "Managing Hospital Units", type: :request do
  let(:hospital_centre) { create(:hospital_centre) }
  let(:hospital_unit) { create(:hospital_unit) }

  describe "GET new" do
    it "responds with a form" do
      get new_hospitals_unit_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:hospital_unit)
          .merge(hospital_centre_id: hospital_centre.id)
        post hospitals_units_path, hospitals_unit: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Hospitals::Unit.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }
        post hospitals_units_path, hospitals_unit: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_hospitals_unit_path(hospital_unit)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = { name: "My Edited Event" }
        patch hospitals_unit_path(hospital_unit), hospitals_unit: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Hospitals::Unit.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }
        patch hospitals_unit_path(hospital_unit), hospitals_unit: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the event type" do
      delete hospitals_unit_path(hospital_unit)
      expect(response).to have_http_status(:redirect)

      expect(Renalware::Hospitals::Unit.exists?(id: hospital_unit.id)).to be_falsey

      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end
end
