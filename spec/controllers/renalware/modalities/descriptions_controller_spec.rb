require "rails_helper"

module Renalware
  describe Modalities::DescriptionsController, type: :controller do

    subject { create(:modality_description) }

    describe "GET new" do
      it "renders the new template" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "POST create" do
      context "with valid attributes" do
        it "creates a new modality description" do
          expect {
            post :create,
            modalities_description: {
              code: "diabetic",
              name: "Renal/Diabetic"
            }
          }.to change(Modalities::Description, :count).by(1)
          expect(response).to redirect_to(modalities_descriptions_path)
        end
      end

      context "with invalid attributes" do
        it "creates a new modality description" do
          expect { post :create,
                   modalities_description: { code: nil, name: nil }
                 }.to change(Modalities::Description, :count).by(0)
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET index" do
      it "responds with success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET edit" do
      it "responds with success" do
        get :edit, id: subject.id
        expect(response).to have_http_status(:success)
      end
    end

    describe "PUT update" do
      context "with valid attributes" do
        it "updates a modality description" do
          put :update, id: subject.id, modalities_description: { name: "Low Clearance" }
          expect(response).to redirect_to(modalities_descriptions_path)
        end
      end

      context "with invalid attributes" do
        it "update a modality description" do
          put :update, id: subject.id, modalities_description: { name: nil }
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "DELETE destroy" do
      it "soft deletes a modality description" do
        @modality_description = create(:modality_description)

        expect { delete :destroy, id: @modality_description }.to(
          change(Modalities::Description, :count).by(-1)
        )

        expect(@modality_description.reload.deleted_at).not_to be_nil
      end
    end

  end
end
