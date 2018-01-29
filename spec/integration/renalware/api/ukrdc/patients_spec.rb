require "rails_helper"

RSpec.describe "API request for a single UKRDC patient XML document", type: :request do
  include PatientsSpecHelper
  include LettersSpecHelper
  include PathologySpecHelper

  let(:user) { @current_user }
  let(:algeria) { create(:algeria) }
  let(:uk) { create(:united_kingdom) }
  let(:english) { create(:language, :english) }
  let(:white_british) { create(:ethnicity, :white_british) }
  let(:patient) do
    create(
      :patient,
      ethnicity: white_british,
      country_of_birth: uk,
      language: english,
      by: user
    )
  end

  def validate(xml)
    document = Nokogiri::XML(xml)
    xsd_path = File.join(Renalware::Engine.root, "vendor", "xsd", "ukrdc/Schema/UKRDC.xsd")
    xsddoc = Nokogiri::XML(File.read(xsd_path), xsd_path)
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
      patient.document.history.smoking = :ex
      patient.practice = create(:practice)
      patient.primary_care_physician = create(:primary_care_physician)
      patient.update!(by: user)
      create(:clinic_visit, patient: clinic_patient(patient), by: user)
      create(:allergy, patient: clinical_patient(patient), by: user)

      hd_patient = Renalware::HD.cast_patient(patient)
      create(:hd_closed_session, patient: hd_patient, by: user)

      # So medications elements are triggered
      create(:prescription, patient: patient, by: user)

      get api_ukrdc_patient_path(patient)

      expect(response).to be_success
      validate(response.body).each do |error|
        puts error.message
        fail
      end
    end

    context "when the patient has died" do
      it "includes first and second cause of death elements" do
        set_modality(
          patient: patient,
          modality_description: create(:modality_description, :death),
          by: user
        )

        patient.first_cause = create(:cause_of_death, code: 11, description: "Abc")
        patient.second_cause = create(:cause_of_death, code: 12, description: "Xyz")
        patient.died_on = Time.zone.now
        patient.save_by!(user)

        expect(patient.reload).to be_current_modality_death

        get api_ukrdc_patient_path(patient)

        expect(response).to be_success

        matches = response.body.scan(/<CauseOfDeath>/)
        expect(matches.length).to eq(2)

        validate(response.body).each do |error|
          puts error.message
          fail
        end
      end
    end
  end

  context "when the patient has pathology" do
    it "includes laborder/resultitems" do
      descriptions = create_descriptions(%w(HGB PLT))
      create_observations(::Renalware::Pathology.cast_patient(patient), descriptions)

      get api_ukrdc_patient_path(patient)

      expect(response).to be_success

      validate(response.body).each do |error|
        puts error.message
        fail
      end
    end
  end

  context "when the patient has a letter" do
    it "validates Document/s element" do
      create_letter(
        to: :patient,
        state: :approved,
        patient: Renalware::Letters.cast_patient(patient),
        description: "xxx"
      )
      get api_ukrdc_patient_path(patient)

      expect(response).to be_success

      validate(response.body).each do |error|
        puts error.message
        fail
      end
    end
  end
end
