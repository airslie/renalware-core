# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "Document element" do
  helper(Renalware::ApplicationHelper)

  subject(:rendered) do
    render(
      partial: partial,
      locals: { patient: presenter, builder: builder }
    )
  end

  let(:partial) { "renalware/api/ukrdc/patients/treatments.xml.builder" }
  let(:builder) { Builder::XmlMarkup.new }
  let(:patient) { create(:patient) }
  let(:presenter) { Renalware::UKRDC::PatientPresenter.new(patient) }
  let(:modality_started_on) { "2018-01-01" }
  let(:modality_ended_on) { nil }
  let(:modality) do
    create(
      :modality,
      patient: patient,
      description: hd_modality_description,
      started_on: modality_started_on,
      ended_on: modality_ended_on
    )
  end
  let(:hd_modality_description) do
    create(
      :modality_description,
      :hd,
      ukrdc_modality_code_id: create(:ukrdc_modality_code, :hd).id
    )
  end

  before { modality }

  it "renders modality FromTime" do
    expect(rendered).to include("<FromTime>2018-01-01</FromTime")
  end

  context "when the modality is current and has no ended_on" do
    let(:modality_ended_on) { nil }

    it "renders modality ToTime" do
      expect(rendered).not_to include("<ToTime")
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

  context "when modality is HD" do
    context "when there is an active profile on the same day" do
      let(:patient) { create(:hd_patient) }

      before do
        create(
          :hd_profile,
          patient: patient,
          prescribed_on: modality_started_on,
          created_at: modality_started_on,
          hospital_unit: create(:hospital_unit, unit_type: :satellite)
        )
      end

      it "outputs QBL05 whichis the hosp unit unit_type mapped to an RR RR8 code" do
        expect(rendered).to include("<QBL05>SATL</QBL05>")
      end
    end
  end
end
