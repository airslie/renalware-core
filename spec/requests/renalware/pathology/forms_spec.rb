require "rails_helper"

describe "Viewing required observations" do
  describe "GET /pathology/forms" do
    let!(:patient_1) { Renalware::Pathology.cast_patient(create(:patient)) }
    let!(:patient_2) { Renalware::Pathology.cast_patient(create(:patient)) }
    let!(:clinic) { create(:clinic) }
    let!(:doctor) { create(:doctor) }

    let!(:patient_rule_2) { create(:pathology_request_algorithm_patient_rule, patient: patient_2) }
    let!(:request_description) { create(:pathology_request_description, name: "B12 Vitamin") }
    let!(:global_rule_set) do
      create(
        :pathology_request_algorithm_global_rule_set,
        frequency_type: "Always",
        clinic: clinic,
        request_description: request_description
      )
    end

    context "given a single patient's form is requested" do
      it "displays a form containing global & patient observations required for the patient" do
        get pathology_forms_path(patient_ids: patient_1.id)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).to include(global_rule_set.request_description.name)
      end
    end

    context "given multiple patient's forms are requested" do
      it "displays a form containing global & patient observations required for the patient" do
        get pathology_forms_path(patient_ids: [patient_1.id, patient_2.id])

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).to include(patient_rule_2.test_description)
        expect(response.body).to include(global_rule_set.request_description.name)
      end
    end
  end
end
