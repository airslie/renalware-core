# frozen_string_literal: true

require "rails_helper"
require "builder"

# rubocop:disable RSpec/ExampleLength
describe "Medications element" do
  helper(Renalware::ApplicationHelper)
  let(:user) { create(:user) }

  def partial_content(patient_presenter)
    render partial: "renalware/api/ukrdc/patients/medications.xml.builder",
           locals: {
             patient: patient_presenter,
             builder: Builder::XmlMarkup.new
           }
  end

  def create_prescription_for(patient, dose_amount: "99", prescribed_on: 1.week.ago)
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
      prescribed_on: prescribed_on
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

  context "when the patient has current and terminated prescriptions" do
    it "returns all prescriptions with appropriate From and To times" do
      patient = create(:patient)
      presenter = Renalware::UKRDC::PatientPresenter.new(patient)
      terminated_prescription = create_prescription_for(
        patient,
        dose_amount: "98",
        prescribed_on: 2.weeks.ago
      )
      terminated_prescription.terminate(by: user, terminated_on: 1.week.ago).save!
      active_prescription = create_prescription_for(
        patient,
        dose_amount: "99",
        prescribed_on: 1.week.ago
      )

      xml = partial_content(presenter)

      expect(xml).to include(<<-XML.squish.gsub("> <", "><"))
        <Medications>
          <Medication>
            <FromTime>#{2.weeks.ago.to_date.iso8601}T00:00:00+00:00</FromTime>
            <ToTime>#{1.week.ago.to_date.iso8601}T00:00:00+00:00</ToTime>
            <EnteringOrganization>
              <CodingStandard>ODS</CodingStandard>
              <Code>RJZ</Code>
            </EnteringOrganization>
            <Route>
              <CodingStandard>RR22</CodingStandard>
              <Code/>
            </Route>
            <DrugProduct>
              <Generic>Drug1</Generic>
            </DrugProduct>
            <Frequency>daily</Frequency>
            <Comments>98 mg daily</Comments>
            <DoseQuantity>98</DoseQuantity>
            <DoseUoM>
              <CodingStandard>LOCAL</CodingStandard>
              <Code>mg</Code>
              <Description>milligram</Description>
            </DoseUoM>
            <ExternalId>#{terminated_prescription.id}</ExternalId>
          </Medication>
          <Medication>
            <FromTime>#{1.week.ago.to_date.iso8601}T00:00:00+00:00</FromTime>
            <EnteringOrganization>
              <CodingStandard>ODS</CodingStandard>
              <Code>RJZ</Code>
            </EnteringOrganization>
            <Route>
              <CodingStandard>RR22</CodingStandard>
              <Code/>
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
            <ExternalId>#{active_prescription.id}</ExternalId>
          </Medication>
        </Medications>
      XML
    end
  end

  context "when the patient has a medication with a numeric dose amount" do
    it "includes a Medication element with a DoseQuantity element" do
      patient = create(:patient)
      presenter = Renalware::UKRDC::PatientPresenter.new(patient)
      prescription = create_prescription_for(patient, dose_amount: "99")

      xml = partial_content(presenter)

      expect(xml).to eq(<<-XML.squish.gsub("> <", "><"))
      <Medications>
        <Medication>
          <FromTime>#{1.week.ago.to_date.iso8601}T00:00:00+00:00</FromTime>
          <EnteringOrganization>
            <CodingStandard>ODS</CodingStandard>
            <Code>RJZ</Code>
          </EnteringOrganization>
          <Route>
            <CodingStandard>RR22</CodingStandard>
            <Code/>
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
          <ExternalId>#{prescription.id}</ExternalId>
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
# rubocop:enable RSpec/ExampleLength
