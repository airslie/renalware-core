# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe GenerateMonthlyStatisticsForPatient do
      include PathologySpecHelper
      subject(:command) { described_class.new(patient: patient, period: period) }

      let(:patient) { create(:hd_patient) }
      let(:period) { MonthPeriod.new(month: 12, year: 2016) }
      let(:hospital_unit) { create(:hospital_unit) }
      let(:month) { 12 }
      let(:year) { 2016 }
      let(:hgb) { create(:pathology_observation_description, code: "HGB", name: "HGB") }
      let(:pth) { create(:pathology_observation_description, code: "PTH", name: "PTH") }
      let(:phos) { create(:pathology_observation_description, code: "PHOS", name: "PHOS") }
      let(:cre) { create(:pathology_observation_description, code: "CRE", name: "CRE") }
      let(:ure) { create(:pathology_observation_description, code: "URE", name: "URE") }

      it "creates a PatientStatistics for the patient with hd sessions in the specified month" do
        travel_to Date.new(2016, 12, 3) do
          create(:hd_closed_session, patient: patient, hospital_unit: hospital_unit)
          create_observations(
            Renalware::Pathology.cast_patient(patient),
            [hgb, phos, pth, cre, ure],
            result: 1.0
          )
        end

        expect { command.call }.to change(PatientStatistics, :count).by(1)

        stats = PatientStatistics.first
        expect(stats.patient.id).to eq(patient.id)
        expect(stats.hospital_unit.id).to eq(hospital_unit.id)
        expect(stats.month).to eq(month)
        expect(stats.year).to eq(year)
        expect(stats.pathology_snapshot).to eq(
          {

            "CRE" => { "result" => "1.0", "observed_at" => "2016-12-03T00:00:00" },
            "HGB" => { "result" => "1.0", "observed_at" => "2016-12-03T00:00:00" },
            "PHOS" => { "result" => "1.0", "observed_at" => "2016-12-03T00:00:00" },
            "PTH" => { "result" => "1.0", "observed_at" => "2016-12-03T00:00:00" },
            "URE" => { "result" => "1.0", "observed_at" => "2016-12-03T00:00:00" }
          }
        )
        expect(stats.rolling).to be_nil
        expect(stats.session_count).to eq(1)
      end
    end
  end
end
