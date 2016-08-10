require "rails_helper"

RSpec.describe "Configuring Modality Descriptions", type: :request do
  let(:modality_description) { create(:modality_description) }

  describe "GET new" do
    it "responds with a form" do
      get new_modalities_description_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:modality_description)

        post modalities_descriptions_path, modalities_description: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Modalities::Description.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }

        post modalities_descriptions_path, modalities_description: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET index" do
    it "responds successfully" do
      get modalities_descriptions_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_modalities_description_path(modality_description)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = { name: "My Edited Modality Description" }

        patch modalities_description_path(modality_description), modalities_description: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Modalities::Description.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }

        patch modalities_description_path(modality_description), modalities_description: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "soft deletes the modality description" do
      delete modalities_description_path(modality_description)

      expect(response).to have_http_status(:redirect)
      expect(Renalware::Modalities::Description.exists?(id: modality_description.id)).to be_falsey

      follow_redirect!

      expect(response).to have_http_status(:success)
    end
  end

end