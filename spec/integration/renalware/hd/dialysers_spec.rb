require "rails_helper"

RSpec.describe "Managing Cannulation Types", type: :request do
  let(:dialyser) { create(:hd_dialyser) }

  describe "GET new" do
    it "responds with a form" do
      get new_hd_dialyser_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:hd_dialyser)
        post hd_dialysers_path, hd_dialyser: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::HD::Dialyser.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }
        post hd_dialysers_path, hd_dialyser: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_hd_dialyser_path(dialyser)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = { name: "Something" }
        patch hd_dialyser_path(dialyser), hd_dialyser: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::HD::Dialyser.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }
        patch hd_dialyser_path(dialyser), hd_dialyser: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the event type" do
      delete hd_dialyser_path(dialyser)
      expect(response).to have_http_status(:redirect)

      expect(Renalware::HD::Dialyser.exists?(id: dialyser.id)).to be_falsey

      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end
end
