require_dependency "renalware/medications"

module Renalware
  module Medications
    class RevisePrescription
      attr_reader :prescription, :params

      NEW_PRESCRIPTION_ATTRS = %w(dose_amount dose_unit frequency).freeze

      def initialize(prescription)
        @prescription = prescription
      end

      def call(params)
        @prescription.assign_attributes(params)
        return false unless @prescription.valid?

        if new_prescription_required?
          @prescription.reload
          TerminateExistingAndCreateNewPescription.new(@prescription, params).call
        else
          @prescription.save
        end
      end

      private

      def new_prescription_required?
        attr_intersection = @prescription.changed_attributes.keys & NEW_PRESCRIPTION_ATTRS
        attr_intersection.count > 0
      end
    end

    class TerminateExistingAndCreateNewPescription
      def initialize(prescription, params)
        @prescription = prescription
        @params = params
      end

      def call
        run_terminate_and_create_transaction
        return true

      rescue ActiveRecord::RecordInvalid
        @prescription.assign_attributes(@params)
        @prescription.valid? # NOTE: This will populate the errors object
        return false
      end

      private

      def run_terminate_and_create_transaction
        Prescription.transaction do
          terminate_existing_prescription
          create_new_prescription
        end
      end

      def terminate_existing_prescription
        return if @prescription.termination.present?

        @prescription.terminate(by: @params[:by]).save!
      end

      def create_new_prescription
        new_prescription = Prescription.new(terminated_prescription_attributes)
        new_prescription.assign_attributes(@params)
        new_prescription.prescribed_on = Date.current
        new_prescription.save!
      end

      def terminated_prescription_attributes
        @prescription.attributes.slice(*included_attributes)
      end

      def included_attributes
        %w(patient_id drug_id treatable_id treatable_type dose_amount dose_unit
          medication_route_id route_description frequency notes provider)
      end
    end
  end
end
