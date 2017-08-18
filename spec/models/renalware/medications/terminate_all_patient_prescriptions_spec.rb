require "rails_helper"

module Renalware::Medications
  RSpec.describe TerminateAllPatientPrescriptions do
    it "terminates all patient prescriptions" do
      user = create(:user)
      patient = create(:patient)
      create(:prescription, patient: patient)
      create(:prescription, patient: patient)
      expect(patient.prescriptions.current.count).to eq(2)

      described_class.call(patient: patient, by: user)

      expect(patient.prescriptions.current.count).to eq(0)
    end
  end
end
