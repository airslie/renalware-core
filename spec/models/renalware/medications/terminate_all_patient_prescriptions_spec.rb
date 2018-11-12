# frozen_string_literal: true

require "rails_helper"

module Renalware::Medications
  RSpec.describe TerminateAllPatientPrescriptions do
    it "terminates all patient prescriptions but leaves untouched previously terminated ones" do
      user = create(:user)
      patient = create(:patient, by: user)

      # Current prescriptions
      create(:prescription, patient: patient)
      create(:prescription, patient: patient)

      previously_terminated_prescription = create(
        :prescription,
        patient: patient,
        prescribed_on: "2017-01-01"
      )
      create(:prescription_termination,
             prescription: previously_terminated_prescription,
             terminated_on: "2018-01-01",
             by: user)

      expect(patient.prescriptions.current.count).to eq(2)

      expect {
        described_class.call(patient: patient, by: user)
      }.to change(patient.prescriptions.current, :count).by(-2)

      # The termination date of this one should be unchanged
      expect(previously_terminated_prescription.reload.terminated_on.to_s).to eq("2018-01-01")
    end
  end
end
