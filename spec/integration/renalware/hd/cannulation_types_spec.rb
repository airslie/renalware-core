require "rails_helper"

RSpec.describe "Managing Cannulation Types", type: :request do
  let(:cannulation_type) { create(:hd_cannulation_type) }

  describe "GET new" do
    it "responds with a form" do
      get new_hd_cannulation_type_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:hd_cannulation_type)
        post hd_cannulation_types_path, hd_cannulation_type: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::HD::CannulationType.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }
        post hd_cannulation_types_path, hd_cannulation_type: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_hd_cannulation_type_path(cannulation_type)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = { name: "Something" }
        patch hd_cannulation_type_path(cannulation_type), hd_cannulation_type: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::HD::CannulationType.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }
        patch hd_cannulation_type_path(cannulation_type), hd_cannulation_type: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the event type" do
      delete hd_cannulation_type_path(cannulation_type)
      expect(response).to have_http_status(:redirect)

      expect(Renalware::HD::CannulationType.exists?(id: cannulation_type.id)).to be_falsey

      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end
end
