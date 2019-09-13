# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "hd_session_observations.xml.builder" do
  helper(Renalware::ApplicationHelper)

  subject(:rendered) do
    render partial: partial, locals: { builder: builder, session: session }
  end

  let(:partial) { "renalware/api/ukrdc/patients/hd_session_observations.xml.builder" }
  let(:builder) { Builder::XmlMarkup.new }
  let(:session) do
    Renalware::HD::Session::Closed.new(
      performed_on: "2018-01-01",
      start_time: "12:01",
      end_time: "16:01"
    )
  end

  context "when there are no measurements" do
    it "renders nothing" do
      expect(rendered).to eq("")
    end
  end

  context "when all measurements are 0" do
    before do
      observations_before = session.document.observations_before
      observations_before.weight = 0.0
      observations_before.blood_pressure.diastolic = 0.0
      observations_before.blood_pressure.systolic = 0.0
      observations_after = session.document.observations_after
      observations_after.weight = 0.0
      observations_after.blood_pressure.diastolic = 0.0
      observations_after.blood_pressure.systolic = 0.0
    end

    it "renders nothing" do
      expect(rendered).to eq("")
    end
  end

  context "when all measurements are ''" do
    before do
      observations_before = session.document.observations_before
      observations_before.weight = ""
      observations_before.blood_pressure.diastolic = ""
      observations_before.blood_pressure.systolic = ""
      observations_after = session.document.observations_after
      observations_after.weight = ""
      observations_after.blood_pressure.diastolic = ""
      observations_after.blood_pressure.systolic = ""
    end

    it "renders nothing" do
      expect(rendered).to eq("")
    end
  end

  describe "pre weight" do
    before do
      observations_before = session.document.observations_before
      observations_before.weight = 0.1
    end

    it do
      is_expected.to eq(<<-XML.squish.gsub("> <", "><"))
        <Observation>
          <ObservationTime>2018-01-01T12:01:00+00:00</ObservationTime>
          <ObservationCode>
            <CodingStandard>UKRR</CodingStandard>
            <Code>QBLG1</Code>
            <Description>Body weight Measured</Description>
          </ObservationCode>
          <ObservationValue>0.1</ObservationValue>
          <ObservationUnits>Kg</ObservationUnits>
          <PrePost>PRE</PrePost>
        </Observation>
      XML
    end
  end

  describe "post systolic" do
    before do
      observations_after = session.document.observations_before
      observations_after.blood_pressure.systolic = 100
    end

    it do
      p rendered
      is_expected.to eq(<<-XML.squish.gsub("> <", "><"))
        <Observation>
          <ObservationTime>2018-01-01T12:01:00+00:00</ObservationTime>
          <ObservationCode>
            <CodingStandard>UKRR</CodingStandard>
            <Code>QBLG3</Code>
            <Description>Blood pressure device Cuff pressure.systolic</Description>
          </ObservationCode>
          <ObservationValue>100</ObservationValue>
          <ObservationUnits>mmHg</ObservationUnits>
          <PrePost>PRE</PrePost>
        </Observation>
      XML
    end
  end
end
