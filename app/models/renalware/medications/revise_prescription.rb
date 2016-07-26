require_dependency "renalware/medications"

module Renalware
  module Medications
    class RevisePrescription
      attr_reader :prescription, :params

      def initialize(prescription)
        @prescription = prescription
      end

      def call(params)
        terminate_existing_prescription(params)
        create_new_prescription(params)
      end

      private

      def terminate_existing_prescription(params)
        prescription.terminate(by: params[:by]).save!
      end

      def create_new_prescription(params)
        new_prescription = Prescription.new(terminated_prescription_attributes)
        new_prescription.assign_attributes(params)
        new_prescription.prescribed_on = Date.current
        new_prescription.save!
      end

      def terminated_prescription_attributes
        prescription.attributes.slice(*included_attributes)
      end

      def included_attributes
        %w(patient_id drug_id treatable_id treatable_type dose_amount dose_unit
          medication_route_id route_description frequency notes provider)
      end
    end
  end
end
