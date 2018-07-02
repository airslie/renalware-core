# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Printing home delivery drugs from the patient prescriptions page", type: :feature do
  let(:patient) { create(:patient) }
  let(:user) { create(:user) }
  let(:drug1) { create(:drug, name: "drug1") }
  let(:drug2) { create(:drug, name: "drug2") }
  let(:drug3) { create(:drug, name: "drug3") }

  it "renders a PDF of the patient's prescriptions (EPO and ESA) that marked as home delivery" do
    user = login_as_clinical
    create(:prescription, drug: drug1, by: user, patient: patient, provider: :home_delivery)

    visit patient_prescriptions_path(
      patient, treatable_type: patient.class, treatable_id: patient
    )

    click_on "Print home delivery drugs"

    expect(page).to have_current_path(
      patient_medications_home_delivery_prescriptions_path(patient, format: :pdf)
    )
  end

  describe "GET index", type: :request do
    context "format: :pdf" do
      it "responds with an inlined PDF by default" do
        get patient_medications_home_delivery_prescriptions_path(patient)

        expect(response).to be_success
        expect(response["Content-Type"]).to eq("application/pdf")
        expected_filename = "#{patient.local_patient_id} prescriptions-for-home-delivery.pdf"
        expect(response["Content-Disposition"]).to eq("inline; filename=\"#{expected_filename}\"")
      end
    end

    context "format: :html (for debugging but lets us interrogate the html)" do
      it "responds with html and correct content" do
        create(:prescription, drug: drug1, by: user, patient: patient, provider: :home_delivery)
        create(:prescription, drug: drug2, by: user, patient: patient, provider: :home_delivery)
        create(:prescription, drug: drug3, by: user, patient: patient, provider: :gp)

        get patient_medications_home_delivery_prescriptions_path(patient, format: :pdf, debug: 1)

        expect(response).to be_success
        expect(response["Content-Type"]).to eq("text/html; charset=utf-8")
        expect(response.body).to include("Home Delivery Medication List")
        expect(response.body).to include(patient.to_s)
        expect(response.body).to include(I18n.l(patient.born_on))
        expect(response.body).to include(patient.nhs_number)
        expect(response.body).to include(patient.local_patient_id)
        expect(response.body).to include(drug1.name)
        expect(response.body).to include(drug2.name)
        expect(response.body).not_to include(drug3.name)
      end
    end
  end
end
