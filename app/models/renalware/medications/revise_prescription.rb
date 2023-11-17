# frozen_string_literal: true

module Renalware
  module Medications
    class RevisePrescription
      attr_reader :prescription, :params

      NEW_PRESCRIPTION_ATTRS = %w(dose_amount dose_unit frequency administer_on_hd stat).freeze

      def initialize(prescription)
        @prescription = prescription
      end

      def call(params)
        @prescription.assign_attributes(params)
        return false unless @prescription.valid?

        if new_prescription_required?
          @prescription.reload
          TerminateExistingAndCreateNewPrescription.new(@prescription, params).call
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

    class TerminateExistingAndCreateNewPrescription
      def initialize(prescription, params)
        @prescription = prescription
        @params = params
      end

      def call
        Prescription.transaction do
          terminate_existing_prescription
          create_new_prescription
        end
      end

      private

      # If we are terminating a give_on_hd prescription then always force terminate it
      def terminate_existing_prescription
        return if @prescription.termination.present? && !new_prescription_is_administer_on_hd?

        @prescription.terminate(by: @params[:by]).save!
      end

      def create_new_prescription
        new_prescription = Prescription.new(terminated_prescription_attributes)
        new_prescription.assign_attributes(@params)
        new_prescription.prescribed_on = Date.current
        assign_future_termination(new_prescription) if new_prescription.administer_on_hd?
        new_prescription.save!
      end

      def terminated_prescription_attributes
        @prescription.attributes.slice(*included_attributes)
      end

      # These are the attributes we copy across from old prescription to the new one before
      # terminating the old one. We overwrite these attributes with incoming values from @params,
      # so perhaps there is no benefit to this approach?
      def included_attributes
        %w(
          patient_id
          drug_id
          treatable_id
          treatable_type
          dose_amount
          dose_unit
          medication_route_id
          route_description
          frequency
          notes
          provider
        )
      end

      # Prescriptions which are administer_on_hd = true should automatically have a future
      # termination according to config.auto_terminate_hd_prescriptions_after_period.
      # If this behaviour is not required, return nil in the
      # auto_terminate_hd_prescriptions_after_period setting.
      # Note we could move this to a listener in the HD namespace and broadcast a message from
      # RevisePrescription#call to let listeners modify the prescription. Its border line though
      # - although we make decisions here based on new_prescription_is_administer_on_hd?
      # and Renalware.config.auto_terminate_hd_prescriptions_after_period etc, we do not reference
      # the HD namespace at all.
      def assign_future_termination(prescription)
        return if prescription.prescribed_on.blank?

        termination_period = Renalware.config.auto_terminate_hd_prescriptions_after_period
        return if termination_period.nil?

        termination = prescription.build_termination
        termination.terminated_on = prescription.prescribed_on + termination_period
        termination.by = @params[:by]
        termination.notes = "HD prescription scheduled to be terminated " \
                            "#{termination_period.in_months} months from start"
      end

      def new_prescription_is_administer_on_hd?
        ActiveModel::Type::Boolean.new.cast(@params[:administer_on_hd])
      end
    end
  end
end
