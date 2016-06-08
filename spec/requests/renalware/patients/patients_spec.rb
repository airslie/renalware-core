require "rails_helper"

RSpec.describe "Managing patients", type: :request do
  let(:patient) { create(:patient) }

  describe "GET new" do
    it "responds with a form" do
      get new_patient_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:patient)
        document = build_document

        post patients_path, patient: attributes.merge(document: document)

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patient.exists?(attributes)).to be_truthy

        created_patient = Renalware::Patient.find_by(attributes)
        expect(created_patient.document).to match_document(document)
        expect(created_patient.created_by).to eq(@current_user)
        expect(created_patient.updated_by).to eq(@current_user)

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = {given_name: ""}
        post patients_path, patient: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_patient_path(patient)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = {given_name: "My Edited Patient"}
        patch patient_path(patient), patient: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patient.exists?(attributes)).to be_truthy

        updated_patient = Renalware::Patient.find_by(attributes)
        expect(updated_patient.updated_by).to eq(@current_user)

        follow_redirect!

        updated_patient = Renalware::Patient.find_by(attributes)
        expect(updated_patient.updated_by).to eq(@current_user)

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = {given_name: ""}
        patch patient_path(patient), patient: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  def build_document
    {
      interpreter_notes: Faker::Lorem.sentence,
      admin_notes: Faker::Lorem.sentence,
      special_needs_notes: Faker::Lorem.sentence,
      next_of_kin: {
        name: Faker::Name.name,
        telephone: Faker::PhoneNumber.phone_number,
        address: address_attributes
      },
      referral: {
        referring_physician_name: Faker::Name.name,
        referral_date: Faker::Date.backward(14),
        referral_type: "Unknown",
        referral_notes: Faker::Lorem.sentence
      },
      pharmacist: {
        name: Faker::Name.name,
        telephone: Faker::PhoneNumber.phone_number,
        address: address_attributes
      },
      distinct_nurse: {
        name: Faker::Name.name,
        telephone: Faker::PhoneNumber.phone_number,
        address: address_attributes
      }
    }
  end

  def address_attributes
    attributes_for(:address)
      .merge(
          name: Faker::Name.name,
          organisation_name: Faker::Company.name,
          street_2: Faker::Address.street_name,
          city: Faker::Address.city,
          county: Faker::Address.state,
          country: Faker::Address.country
        )
  end
end
