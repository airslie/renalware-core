# frozen_string_literal: true

module Renalware
  module HD
    # Find the lastest PrescriptionAdministration for a particular prescription - ie the last time
    # it was given.
    class PrescriptionLastAdministrationQuery
      pattr_initialize [:prescription!]
      delegate :patient, to: :prescription

      def call
        raise ArgumentError if prescription.blank?
        raise ArgumentError if patient.blank?

        hd_patient
          .prescription_administrations
          .where(prescription: prescription, administered: true)
          .order(recorded_on: :desc, created_at: :desc)
          .first
      end

      private

      def hd_patient
        HD.cast_patient(patient)
      end
    end
  end
end
