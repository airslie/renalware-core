require "rails_helper"

module Renalware::Drugs
  RSpec.describe DrugsController, :type => :controller do

    describe "DELETE to destroy" do
      it "returns http success" do
        drug = create(:drug)
        delete :destroy, id: drug.id
        drug.reload
        expect(drug.deleted_at).not_to be nil
        expect(response).to have_http_status(:found)
      end
    end

    describe "GET #new" do
      it "renders the new template" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "GET index" do
      it "assigns drugs" do
        create(:drug)

        get :index
        expect(assigns(:drugs).first).to be_a(Drug)
      end
    end

    describe "GET #index" do

      let(:page) { double(:page) }
      let(:result) { double(:result, page: page) }
      let(:search) { double(:search, result: Drug.none) }

      it "responds successfully" do
        get :index
        expect(response).to have_http_status(:success)
      end

      context "with no params" do
        it "returns all drugs" do
          expect(Drug).to receive(:search).and_return(search)
          expect(search).to receive(:sorts=).with("name")

          get :index
        end
      end

      context "with search params" do
        it "searches for drugs" do
          expect(Drug).to receive(:search).and_return(search)
          expect(search).to receive(:sorts=).with("name")

          get :index, q: { name_cont: "cillin" }
        end
      end

      context "with pagination params" do
        it "assigns paging variables" do
          get :index,  {q: {name_cont: "cillin"}, page: "2", per_page: "50"}

          expect(assigns(:page)).to eq("2")
          expect(assigns(:per_page)).to eq("50")
        end
      end

      context "as JSON" do
        it "responds with JSON" do
          expect(Drug).to receive(:search).and_return(search)
          allow(search).to receive(:result).and_return(Drug.none)
          expect(search).to receive(:sorts=).with("name")

          get :index, format: :json

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_a(Array)
        end
      end

    end
  end
end
