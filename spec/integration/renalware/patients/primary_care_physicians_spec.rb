require "rails_helper"

module Renalware
  RSpec.describe "Configuring Primary Care Physicians", type: :request do
    let(:primary_care_physician) { create(:primary_care_physician) }

    describe "GET new" do
      it "responds with a form" do
        get new_patients_primary_care_physician_path

        expect(response).to have_http_status(:success)
      end
    end

    describe "POST create" do
      context "given valid attributes" do
        it "creates a new record" do
          address_attributes = attributes_for(:address)
          primary_care_physician_attributes = attributes_for(:primary_care_physician)
          primary_care_physician_address_attributes =
            primary_care_physician_attributes.merge(address_attributes: address_attributes)

          post patients_primary_care_physicians_path,
               params: {
                 patients_primary_care_physician: primary_care_physician_address_attributes
               }
          expect(response).to have_http_status(:redirect)
          expect(Patients::PrimaryCarePhysician.exists?(primary_care_physician_attributes)).to(
            be_truthy
          )
          expect(Address.exists?(address_attributes)).to be_truthy

          follow_redirect!

          expect(response).to have_http_status(:success)
        end
      end

      context "given invalid attributes" do
        it "responds with form" do
          attributes = { given_name: "" }

          post patients_primary_care_physicians_path,
               params: { patients_primary_care_physician: attributes }

          expect(response).to have_http_status(:success)
        end
      end
    end

    describe "GET index" do
      it "responds successfully" do
        get patients_primary_care_physicians_path

        expect(response).to have_http_status(:success)
      end
    end

    describe "GET edit" do
      it "responds with a form" do
        get edit_patients_primary_care_physician_path(primary_care_physician)

        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH update" do
      context "given valid attributes" do
        it "updates a record" do
          attributes = { given_name: "My GP" }
          patch patients_primary_care_physician_path(primary_care_physician),
                params: { patients_primary_care_physician: attributes }

          expect(response).to have_http_status(:redirect)
          expect(Patients::PrimaryCarePhysician.exists?(attributes)).to be_truthy

          follow_redirect!

          expect(response).to have_http_status(:success)
        end
      end

      context "given invalid attributes" do
        it "responds with a form" do
          attributes = { given_name: "" }
          patch patients_primary_care_physician_path(primary_care_physician),
                params: { patients_primary_care_physician: attributes }

          expect(response).to have_http_status(:success)
        end
      end
    end

    describe "DELETE destroy" do
      it "deletes the primary_care_physician" do
        delete patients_primary_care_physician_path(primary_care_physician)

        expect(response).to have_http_status(:redirect)
        expect(Patients::PrimaryCarePhysician.exists?(id: primary_care_physician.id)).to(
          be_falsey
        )

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end
  end
end
