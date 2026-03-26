module Renalware
  module Medications
    class OutpatientPrescriptionAdministrationsQuery
      pattr_initialize [:prescription!]
      delegate :patient, to: :prescription

      def self.call(prescription:, limit: 1)
        new(prescription:).call(limit:)
      end

      def call(limit: 1)
        raise ArgumentError if prescription.blank?
        raise ArgumentError if patient.blank?

        patient
          .outpatient_prescription_administrations
          .where(prescription:, administered: true)
          .order(recorded_on: :desc, created_at: :desc)
          .limit(limit)
      end
    end
  end
end
