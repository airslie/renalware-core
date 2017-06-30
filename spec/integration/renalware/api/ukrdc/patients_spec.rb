require "rails_helper"

RSpec.describe "API request for a single UKRDC patient XML document", type: :request do
  let(:user) { create(:user) }

  def validate(document, schema_path, root_element)
    xsddoc = Nokogiri::XML(File.read(schema_path), schema_path)
    schema = Nokogiri::XML::Schema.from_document(xsddoc)
    schema.validate(document)
  end

  def clinic_patient(patient)
    Renalware::Clinics.cast_patient(patient)
  end

  def clinical_patient(patient)
    Renalware::Clinical.cast_patient(patient)
  end

  describe "GET #show" do
    it "renders the correct UK RDC XML" do
      ethnicity = create(:ethnicity)
      patient = create(:patient, ethnicity: ethnicity)
      patient.document.history.smoking = :ex
      patient.practice = create(:practice)
      patient.primary_care_physician = create(:primary_care_physician)
      patient.update!(by: user)
      create(:clinic_visit, patient: clinic_patient(patient))
      create(:allergy, patient: clinical_patient(patient), by: user)

      get api_ukrdc_patient_path(patient)

      expect(response).to be_success
      document = Nokogiri::XML(response.body)
      xsd_path = File.join(Renalware::Engine.root, "vendor", "xsd", "ukrdc/Schema/UKRDC.xsd")
      validate(document, xsd_path, "PatientRecord").each do |error|
        p error.message
        fail
      end
    end
  end
end
