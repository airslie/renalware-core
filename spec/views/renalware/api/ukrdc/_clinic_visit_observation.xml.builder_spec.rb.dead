# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "ClinicVisitObservation" do
  helper(Renalware::ApplicationHelper)

  subject(:rendered) do
    render partial: partial, locals: { builder: builder, visit: visit, method: method }
  end

  let(:partial) { "renalware/api/ukrdc/patients/clinic_visit_observation.xml.builder" }
  let(:builder) { Builder::XmlMarkup.new }
  let(:visit) { Renalware::Clinics::ClinicVisit.new }

  describe "handling blank values" do
    let(:method) { :weight }

    context "when nil" do
      before { visit.weight = nil }

      it { is_expected.to eq("") }
    end

    context "when 0.0" do
      before { visit.weight = 0.0 }

      it { is_expected.to eq("") }
    end

    context "when a string" do
      before { visit.weight = "kjhkjhkjhkjhkjhkjh" }

      it { is_expected.to eq("") }
    end
  end

  describe "weight" do
    let(:method) { :weight }

    before { visit.weight = 0.1 }

    it do
      is_expected.to eq(<<-XML.squish.gsub("> <", "><"))
        <Observation>
          <ObservationTime/>
          <ObservationCode>
            <CodingStandard>UKRR</CodingStandard>
            <Code>QBLG1</Code>
            <Description>Body weight Measured</Description>
          </ObservationCode>
          <ObservationValue>0.1</ObservationValue>
          <ObservationUnits>Kg</ObservationUnits>
          <Clinician>
            <Description/>
          </Clinician>
        </Observation>
      XML
    end
  end

  describe "#systolic_bp" do
    let(:method) { :systolic_bp }

    context "when the value evaluates as a number but is actually longer than 20 chars" do
      before { visit.systolic_bp = "123                 123" }

      it { is_expected.to match("<ObservationValue>123</ObservationValue>") }
    end
  end
end
