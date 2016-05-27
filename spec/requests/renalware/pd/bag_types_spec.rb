require "rails_helper"

RSpec.describe "Configuring PD Bag Types", type: :request do
  let(:bag_type) { create(:bag_type) }

  describe "GET new" do
    it "responds with a form" do
      get new_bag_type_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:bag_type)
        post bag_types_path, bag_type: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::BagType.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = { manufacturer: "" }
        post bag_types_path, bag_type: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET index" do
    it "responds successfully" do
      get bag_types_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_bag_type_path(bag_type)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = { manufacturer: "My Edited Bag Type" }

        patch bag_type_path(bag_type), bag_type: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::BagType.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = { manufacturer: "" }

        patch bag_type_path(bag_type), bag_type: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the bag type" do
      delete bag_type_path(bag_type)

      expect(response).to have_http_status(:redirect)
      expect(Renalware::BagType.exists?(id: bag_type.id)).to be_falsey

      follow_redirect!

      expect(response).to have_http_status(:success)
    end
  end
end