# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "Document element" do
  helper(Renalware::ApplicationHelper)

  subject(:rendered) do
    render(
      partial: partial,
      locals: { modality: presenter, builder: builder }
    )
  end

  let(:partial) { "renalware/api/ukrdc/patients/encounters/treatment.xml.builder" }
  let(:builder) { Builder::XmlMarkup.new }
  let(:patient) { build_stubbed(:patient) }
  let(:presenter) { Renalware::UKRDC::ModalityPresenter.new(modality) }
  let(:modality_started_on) { "2018-01-01" }
  let(:modality_ended_on) { nil }
  let(:modality) do
    build_stubbed(
      :modality,
      patient: patient,
      description: hd_modality_description,
      started_on: modality_started_on,
      ended_on: modality_ended_on
    )
  end
  let(:hd_modality_description) { build_stubbed(:modality_description, :hd) }

  it "renders modality FromTime" do
    expect(rendered).to include("<FromTime>2018-01-01</FromTime")
  end

  context "when the modality is current and has no ended_on" do
    let(:modality_ended_on) { nil }

    it "renders modality ToTime" do
      expect(rendered).to include("<ToTime/>")
    end
  end

  context "when the modality is current and has no ended_on" do
    let(:modality_ended_on) { "2018-12-31" }

    it "renders modality ToTime" do
      expect(rendered).to include("<ToTime>2018-12-31</ToTime>")
    end
  end

  it "renders the HealthCareFacility" do
    allow(Renalware.config).to receive(:ukrdc_site_code).and_return("ABC")

    expect(rendered).to include(
      "<HealthCareFacility><CodingStandard>ODS</CodingStandard><Code>ABC</Code>"
    )
    expect(Renalware.config).to have_received(:ukrdc_site_code)
  end
end
