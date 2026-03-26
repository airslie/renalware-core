module Renalware
  module Medications
    class OutpatientPrescriptionAdministration < ApplicationRecord
      include Accountable

      acts_as_paranoid

      attr_accessor(
        :skip_witness_validation,
        :skip_administrator_validation,
        :administered_by_password,
        :witnessed_by_password
      )

      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :prescription, class_name: "Medications::Prescription"
      belongs_to :administered_by, class_name: "User", optional: true
      belongs_to :witnessed_by, class_name: "User", optional: true
      belongs_to :reason,
                 class_name: "OutpatientPrescriptionAdministrationReason",
                 optional: true

      validates :patient, presence: true
      validates :recorded_on, presence: true
      validates :administered, inclusion: { in: [true, false] }
      validates :prescription, presence: true
      validates :administered_by, presence: true, if: :validate_administrator?
      validates :witnessed_by, presence: true, if: :validate_witness?
      validate :prescription_is_for_outpatient_administration
      validate :patient_matches_prescription
      validate :check_administered_by_password, if: :validate_administrator?
      validate :check_witnessed_by_password, if: :validate_witness?
      validate :witness_cannot_be_administrator

      before_validation :assign_patient_from_prescription

      scope :ordered, -> { order(recorded_on: :desc, created_at: :desc) }

      def authorised?
        return true unless administered?

        signed_off_at.present?
      end

      def witnessed?
        administered? && authorised?
      end

      private

      def assign_patient_from_prescription
        self.patient ||= prescription&.patient
      end

      def prescription_is_for_outpatient_administration
        return if prescription.blank?
        return if prescription.give_as_outpatient?

        errors.add(:prescription, "must have give_as_outpatient enabled")
      end

      def patient_matches_prescription
        return if patient.blank? || prescription.blank?
        return if patient == prescription.patient

        errors.add(:patient, "must match the prescription patient")
      end

      def witness_cannot_be_administrator
        return unless authorised?
        return if administered_by_id.blank? || witnessed_by_id.blank?
        return unless administered_by_id == witnessed_by_id

        errors.add(:witnessed_by_id, "Must be a different user")
      end

      def validate_witness?
        return false if not_administered?
        return false if skip_witness_validation

        true
      end

      def validate_administrator?
        return false if not_administered?
        return false if skip_administrator_validation

        true
      end

      def not_administered?
        administered.nil? || administered == false
      end

      def check_administered_by_password
        return if administered_by.blank?

        self.administrator_authorised = false
        handle_ldap_error_for(:administered_by_password) do
          if administered_by.valid_password?(administered_by_password)
            self.administrator_authorised = true
            set_signed_off_at_if_fully_authorised
          else
            errors.add(:administered_by_password, "Invalid password")
          end
        end
      end

      def check_witnessed_by_password
        return if witnessed_by.blank?

        handle_ldap_error_for(:witnessed_by_password) do
          self.witness_authorised = false
          if witnessed_by.valid_password?(witnessed_by_password)
            self.witness_authorised = true
            set_signed_off_at_if_fully_authorised
          else
            errors.add(:witnessed_by_password, "Invalid password")
          end
        end
      end

      def set_signed_off_at_if_fully_authorised
        return unless administrator_authorised?
        return if skip_witness_validation

        self.signed_off_at = Time.current if witness_authorised?
      end

      def handle_ldap_error_for(error_field)
        yield
      rescue Ldap::Error => e
        Rails.logger.error "LDAP error during password check: #{e.message}"
        errors.add(error_field, I18n.t("renalware.system.errors.ldap.service_unavailable"))
      end
    end
  end
end
