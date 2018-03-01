# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe GenerateMonthlyStatisticsForPatient do
      subject(:command) { described_class.new(patient: patient, period: period) }

      let(:patient) { create(:hd_patient) }
      let(:period) { MonthPeriod.new(month: 12, year: 2016) }
      let(:hospital_unit) { create(:hospital_unit) }
      let(:month) { 12 }
      let(:year) { 2016 }

      it "creates a PatientStatistics for the patient with hd sessions in the specified month" do
        travel_to Date.new(2016, 12, 3) do
          create(:hd_closed_session, patient: patient, hospital_unit: hospital_unit)
        end

        expect { command.call }.to change { PatientStatistics.count }.by(1)

        stats = PatientStatistics.first
        expect(stats.patient.id).to eq(patient.id)
        expect(stats.hospital_unit.id).to eq(hospital_unit.id)
        expect(stats.month).to eq(month)
        expect(stats.year).to eq(year)
        expect(stats.rolling).to be_nil
        expect(stats.session_count).to eq(1)
      end
    end
  end
end
