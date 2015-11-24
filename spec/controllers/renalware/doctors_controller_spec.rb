require "rails_helper"

module Renalware
  describe DoctorsController, type: :controller do

    describe "GET index" do
      let(:doctors) { Doctor.none }
      let(:paginator) { double(:paginator, per: doctors) }

      it "is successful" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "assigns a collection of Doctors" do
        expect(Doctor).to receive(:page).and_return(paginator)
        get :index
        expect(assigns(:doctors)).to eq(doctors)
      end
    end

    describe "GET new" do
      before do
        get :new
      end

      it "is successful" do
        expect(response).to have_http_status(:success)
      end
      it "renders a form" do
        expect(response).to render_template(:new)
      end
      it "assigns a new instance of Doctor" do
        expect(assigns(:doctor)).to be_a(Doctor)
      end
    end

    describe "POST create" do
      before do
        address_params = {
          street_1: "123 South Street",
          postcode: "NW9 3JU"
        }

        @doctor_params = {
          given_name: "Lall",
          family_name: "Sawh",
          email: "lall.sawh@nhs.net",
          code: "GP54321",
          practitioner_type: "GP",
          address_attributes: address_params
        }
      end

      it "saves a new Doctor" do
        expect {
          post :create, doctor: @doctor_params
        }.to change(Doctor, :count).by(1)
      end

      it "saves a new Address" do
        address_params = { street_1: "123 South Street", postcode: "N1 1NN" }
        expect {
          post :create, doctor: @doctor_params.merge(address_attributes: address_params)
        }.to change(Address, :count).by(1)
      end

      it "redirects to doctors index when successful" do
        post :create, doctor: @doctor_params
        expect(response).to redirect_to(doctors_path)
      end

      it "renders the form when unsuccessful" do
        expect_any_instance_of(DoctorService).to receive(:update!).and_return(false)

        post :create, doctor: { given_name: "Lall" }
        expect(response).to render_template(:new)
      end
    end

    describe "PUT edit" do
      before do
        @doc = create(:doctor)
      end

      it "updates an existing Doctor" do
        put :update, id: @doc.to_param, doctor: { given_name: "James" }
        expect(@doc.reload.given_name).to eq("James")
      end
      it "redirects to the doctors index when successful" do
        put :update, id: @doc.to_param, doctor: { given_name: "James" }
        expect(response).to redirect_to(doctors_path)
      end
    end

    describe "DELETE destroy" do
      before do
        @doc = create(:doctor)
      end
      it "deletes an existing Doctor" do
        expect {
          delete :destroy, id: @doc.to_param
        }.to change(Doctor, :count).by(-1)
      end
      it "redirects to the doctors index when successful" do
        delete :destroy, id: @doc.to_param
        expect(response).to redirect_to(doctors_path)
      end
    end
  end
end
