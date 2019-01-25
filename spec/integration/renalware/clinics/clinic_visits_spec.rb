# frozen_string_literal: true

require "rails_helper"

describe "Clinic Visits Management", type: :request do
  let(:user) { @current_user }
  let(:clinic) { create(:clinic) }
  let(:patient) { Renalware::Clinics.cast_patient(create(:patient, by: user)) }

  describe "GET index" do
    before do
      get patient_clinic_visits_path(patient_id: patient.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end
  end

  describe "GET new" do
    it "responds successfully" do
      get new_patient_clinic_visit_path(patient_id: patient.to_param)
      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "when the clinic does not have a visit_class_name" do
      let(:clinic) { create(:clinic, visit_class_name: "") }

      it "responds successfully" do
        params = {
          clinic_visit: {
            date: Time.zone.today,
            time: Time.zone.parse("2000-01-01 14:44:44"),
            clinic_id: clinic.id,
            did_not_attend: false,
            height: 1.75,
            weight: 89.2,
            bp: "110/78",
            urine_blood: "neg",
            urine_protein: "neg",
            notes: "Nothing unusual",
            admin_notes: "XYZ",
            pulse: 123,
            standing_bp: "110/80"
          }
        }
        post patient_clinic_visits_path(patient_id: patient.to_param), params: params

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful

        visit = patient.clinic_visits.first
        expect(visit).to have_attributes(params[:clinic_visit])
        expect(visit.type).to be_blank # its the base STI type eg Clinics:ClinicVisit
      end
    end

    context "when the clinic#visit_class_name is a custom visit class name" do
      let(:clinic) { create(:clinic, visit_class_name: "MyClinicVisit") }

      class MyClinicVisit < Renalware::Clinics::ClinicVisit
      end

      it "responds successfully" do
        params = {
          clinic_visit: {
            date: Time.zone.today,
            time: Time.zone.parse("2000-01-01 14:44:44"),
            clinic_id: clinic.id,
            did_not_attend: false,
            height: 1.75,
            weight: 89.2,
            bp: "110/78",
            urine_blood: "neg",
            urine_protein: "neg",
            notes: "Nothing unusual",
            admin_notes: "XYZ",
            pulse: 123,
            standing_bp: "110/80"
          }
        }

        pending
        # getting
        #  ActiveModel::UnknownAttributeError Exception: unknown attribute 'date' for MyClinicVisit.
        #  or
        #  undefined method `write_from_user' for nil:NilClass
        # in clinics/create_clinic_visit.rb:56:in `build_clinic_visit'"
        # very odd. Migght be to do with our test class.

        post patient_clinic_visits_path(patient_id: patient.to_param), params: params

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful

        visit = patient.clinic_visits.first
        expect(visit).to have_attributes(params[:clinic_visit])
        expect(visit.type).to eq("MyClinicVisit")
      end
    end
  end

  describe "GET edit" do
    before do
      clinic_visit = create(:clinic_visit, patient: patient, by: user)
      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end
  end

  describe "PUT update" do
    before do
      clinic_visit = create(:clinic_visit, patient: patient, by: user)
      put patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param),
          params: {
            clinic_visit: {
              date: Time.zone.today,
              time: Time.zone.now,
              did_not_attend: false,
              height: 1.75, weight: 89.2, bp: "110/70",
              urine_blood: "neg", urine_protein: "neg",
              notes: "Nothing unusual"
            }
          }
    end

    it "redirects to the clinic_visits index" do
      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end
  end

  describe "DELETE destroy" do
    it "deletes a clinic_visit" do
      clinic_visit = create(:clinic_visit, patient: patient, by: user)
      expect {
        delete patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
      }.to change(patient.clinic_visits, :count).by(-1)
    end
  end
end
