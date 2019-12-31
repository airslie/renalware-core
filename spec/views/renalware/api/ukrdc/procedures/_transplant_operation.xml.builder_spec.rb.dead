# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "TransplantProcedure" do
  helper(Renalware::ApplicationHelper)

  subject(:rendered) do
    render partial: partial, locals: { operation: presenter, builder: builder }
  end

  let(:hospital) { build(:hospital_centre, code: "ABC", name: "Centre1") }
  let(:presenter) { Renalware::UKRDC::TransplantOperationPresenter.new(operation) }
  let(:operation) do
    build(
      :transplant_recipient_operation,
      performed_on: "2019-02-01",
      hospital_centre: hospital,
      operation_type: :kidney
    )
  end
  let(:partial) { "renalware/api/ukrdc/patients/procedures/transplant_operation.xml.builder" }
  let(:builder) { Builder::XmlMarkup.new }
  let(:kidney_tx_snomed_code) do
    Renalware::UKRDC::TransplantOperationPresenter::SNOMED_KIDNEY[:code]
  end
  let(:kidney_tx_name) do
    Renalware::UKRDC::TransplantOperationPresenter::SNOMED_KIDNEY[:name]
  end

  it { is_expected.to include("<ProcedureTime>2019-02-01T00:00:00+00:00</ProcedureTime>") }
  it { is_expected.to include("<EnteredAt>") }
  it { is_expected.to include("<Code>ABC</Code>") }
  it { is_expected.to include("<Description>Centre1</Description>") }
  it { is_expected.to include("<ProcedureType>") }
  it { is_expected.to include("<CodingStandard>SNOMED</CodingStandard>") }
  it { is_expected.to include("<Code>#{kidney_tx_snomed_code}</Code>") }
  it { is_expected.to include("<Description>#{kidney_tx_name}</Description>") }
  it { is_expected.to include("<Attributes>") }
end
