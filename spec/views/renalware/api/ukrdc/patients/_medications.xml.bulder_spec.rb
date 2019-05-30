# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "Medications element" do
  helper(Renalware::ApplicationHelper)

  def partial_content(patient_presenter)
    render partial: "renalware/api/ukrdc/patients/medications.xml.builder",
           locals: {
             patient: patient_presenter,
             builder: Builder::XmlMarkup.new
           }
  end

  def create_prescription_for(patient, dose_amount: "99")
    drug = create(:drug, name: "Drug1")
    route = create(:medication_route, code: "Route1", name: "Route1")
    create(
      :prescription,
      patient: patient,
      drug: drug,
      frequency: "daily",
      dose_amount: dose_amount,
      dose_unit: "milligram",
      medication_route: route,
      prescribed_on: 1.week.ago
    )
  end

  context "when the patient has no medications" do
    it "does not include any Medication elements" do
      patient = create(:patient)
      presenter = Renalware::UKRDC::PatientPresenter.new(patient)

      xml = partial_content(presenter)

      expect(xml).to include("<Medications>")
      expect(xml).not_to include("<Medication>")
    end
  end

  context "when the patient has a medication with a numeric dose amount" do
    it "includes a Medication element with a DoseQuantity element" do
      patient = create(:patient)
      presenter = Renalware::UKRDC::PatientPresenter.new(patient)
      create_prescription_for(patient, dose_amount: "99")

      xml = partial_content(presenter)

      p xml

      expect(xml).to eq(<<-XML.squish.gsub("> <", "><"))
      <Medications>
        <Medication>
          <FromTime>#{1.week.ago.to_date.iso8601}T00:00:00+00:00</FromTime>
          <Route>
            <CodingStandard>RR22</CodingStandard>
            <Code/>
            <Description>Route1</Description>
          </Route>
          <DrugProduct>
            <Generic>Drug1</Generic>
          </DrugProduct>
          <Frequency>daily</Frequency>
          <Comments>99 mg daily</Comments>
          <DoseQuantity>99</DoseQuantity>
          <DoseUoM>
            <CodingStandard>LOCAL</CodingStandard>
            <Code>mg</Code>
            <Description>milligram</Description>
          </DoseUoM>
        </Medication>
      </Medications>
      XML
    end
  end

  context "when the patient has a medication with a numeric dose amount" do
    it "includes a Medication element omitting the DoseQuantity" do
      patient = create(:patient)
      presenter = Renalware::UKRDC::PatientPresenter.new(patient)
      create_prescription_for(patient, dose_amount: "> 99")

      xml = partial_content(presenter)

      expect(xml).not_to include("<DoseQuantity>")
    end
  end
end
