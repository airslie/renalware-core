module Renalware
  module Medications
    module FixedDosePrescriptionTermination
      extend ActiveSupport::Concern

      included do
        before_save :terminate_prescription_if_required_number_of_doses_reached
      end

      private

      def terminate_prescription_if_required_number_of_doses_reached
        return unless valid?
        return unless prescription_in_fixed_dose_administration_context?
        return unless administered?
        return if prescription.fixed_number_of_doses.blank?
        return unless administered_doses_count >= prescription.fixed_number_of_doses

        terminate_prescription_or_update_future_termination(
          prescription:,
          notes: termination_notes_for_fixed_number_of_doses
        )
      end

      def termination_notes_for_fixed_number_of_doses
        count = prescription.fixed_number_of_doses

        "Prescription automatically terminated after #{count} administered " \
          "#{'dose'.pluralize(count)}"
      end

      def terminate_prescription_or_update_future_termination(prescription:, notes:)
        if prescription.termination.nil?
          terminate_prescription(prescription, notes)
        elsif prescription.termination.terminated_on > Time.zone.today
          update_existing_future_termination_to_terminate_immediately(prescription)
        end
      end

      def terminate_prescription(prescription, notes)
        prescription.build_termination(
          terminated_on: Time.zone.now,
          notes:,
          by: SystemUser.find
        ).save!
      end

      def update_existing_future_termination_to_terminate_immediately(prescription)
        termination = prescription.termination
        termination.terminated_on = Time.zone.today
        termination.created_by = termination.updated_by = SystemUser.find
        termination.save!
      end

      def administered_doses_count
        AdministeredDosesQuery.count(
          prescription:,
          excluding_administration: self
        ) + 1
      end
    end
  end
end
