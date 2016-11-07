require "rails_helper"

module Renalware::HD
  RSpec.describe UpdateRollingPatientStatistics do
    let(:patient) { create(:hd_patient) }
    let(:user) { create(:user) }
    let(:hospital_unit) { create(:hospital_unit) }
    subject(:command) { described_class.new(patient: patient) }

    it "creates a new rolling PatientStatistics row if one did not exist" do
      expect(PatientStatistics.count).to eq(0)

      create(:hd_open_session, patient: patient, created_by: user, hospital_unit: hospital_unit)
      create(:hd_closed_session, patient: patient, created_by: user, hospital_unit: hospital_unit)
      create(:hd_closed_session, patient: patient, created_by: user, hospital_unit: hospital_unit)
      create(:hd_dna_session, patient: patient, created_by: user, hospital_unit: hospital_unit)

      subject.call

      expect(PatientStatistics.count).to eq(1)
      patient_statistics = PatientStatistics.first
      expect(patient_statistics.hospital_unit).to eq(hospital_unit)
      expect(patient_statistics.session_count).to eq(3) # excludes open

      Sessions::AuditableSessionCollection::AUDITABLE_ATTRIBUTES.each do |attr|
        expect(patient_statistics[attr]).to_not be_nil
      end
    end

  end
end
