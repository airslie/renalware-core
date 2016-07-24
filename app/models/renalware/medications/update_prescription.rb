require_dependency "renalware/medications"

module Renalware
  module Medications
    class UpdatePrescription
      attr_reader :prescription, :params

      def initialize(prescription, params)
        @prescription = prescription
        @params = params
      end

      def call
        terminate_existing_prescription
        create_new_prescription
      end

      private

      def terminate_existing_prescription
        prescription.terminate(by: params[:by]).save!
      end

      def create_new_prescription
        new_attributes =
          prescription
            .attributes
            .except(*excluded_attributes)
            .merge(prescribed_on: Date.current)

        new_prescription = Renalware::Medications::Prescription.new(new_attributes)
        new_prescription.assign_attributes(params)
        new_prescription.save!
      end

      def excluded_attributes
        %w(id prescribed_on terminated_on created_at updated_at created_by_id updated_by_id)
      end
    end
  end
end
