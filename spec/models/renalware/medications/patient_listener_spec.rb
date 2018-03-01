# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    RSpec.describe PatientListener do
      subject(:listener) { described_class.new }

      describe "#patient_modality_changed_to_death" do
        it "terminates all prescriptions if the modality description type is death" do
          patient = build_stubbed(:patient)
          user = build_stubbed(:user)

          expect(TerminateAllPatientPrescriptions)
            .to receive(:call)
            .with(patient: patient, by: user)

          listener.patient_modality_changed_to_death(
            patient: patient,
            modality: Object.new,
            actor: user)
        end
      end
    end
  end
end
