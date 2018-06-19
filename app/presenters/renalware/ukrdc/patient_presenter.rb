# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module UKRDC
    class PatientPresenter < SimpleDelegator
      attr_reader :changes_since, :changes_up_until
      delegate :profile, to: :renal_patient, allow_nil: true
      delegate :first_seen_on, to: :profile, allow_nil: true
      alias_attribute :home_telephone, :telephone1
      alias_attribute :mobile_telephone, :telephone2

      def initialize(patient, changes_since: nil)
        if changes_since.present? && changes_since.is_a?(String)
          changes_since = Time.zone.parse(changes_since)
        end
        @changes_since = changes_since || patient.sent_to_ukrdc_at
        if @changes_since.blank?
          raise(
            ArgumentError,
            "No date for comparison: patient#sent_to_ukrdc_at and changes_since are nil"
          )
        end
        @changes_up_until = Time.zone.now
        super(patient)
      end

      def language
        return if super.nil? || super.name == "Unknown"
        super
      end

      def dead?
        current_modality_death?
      end

      def current_modality_hd?
        return false if current_modality.blank?
        current_modality.description.is_a?(Renalware::HD::ModalityDescription)
      end

      def smoking_history
        @smoking_history ||= document.history&.smoking&.upcase
      end

      def letters
        CollectionPresenter.new(
          letters_patient
            .letters
            .approved
            .where("updated_at > ?", changes_since),
          Renalware::Letters::LetterPresenterFactory
        )
      end

      def finished_hd_sessions
        hd_patient
          .finished_hd_sessions
          .includes(:patient, :dialysate)
          .where("hd_sessions.updated_at > ?", changes_since)
      end

      def current_registration_status_rr_code
        @current_registration_status_rr_code ||= begin
          status = transplant_patient.current_registration_status
          status&.description&.rr_code
        end
      end

      def hospital_unit_code
        letter_head.site_code
      end

      def contact_details?
        email || home_telephone || mobile_telephone
      end

      def allergies
        clinical_patient
          .allergies
          .where("recorded_at >= ?", changes_since)
      end

      def clinic_visits
        clinics_patient
          .clinic_visits
          .where("date >= ?", changes_since)
          .includes(:updated_by)
      end

      def prescriptions
        __getobj__.prescriptions
          .includes(:termination, :medication_route, :drug)
          .where("updated_at > ?", changes_since)
      end

      def observation_requests
        pathology_patient
          .observation_requests
          .eager_load(
            :description,
            observations: { description: :measurement_unit }
          )
          .where(patient_id: id)
          .where("requested_at >= ?", changes_since)
          .where("loinc_code is not null")
      end

      private

      def clinical_patient
        @clinical_patient ||= Renalware::Clinical.cast_patient(__getobj__)
      end

      def clinics_patient
        @clinic_patient ||= Renalware::Clinics.cast_patient(__getobj__)
      end

      def letters_patient
        @letters_patient ||= Renalware::Letters.cast_patient(__getobj__)
      end

      def pathology_patient
        @pathology_patient ||= Renalware::Pathology.cast_patient(__getobj__)
      end

      def renal_patient
        @renal_patient ||= Renalware::Renal.cast_patient(__getobj__)
      end

      def transplant_patient
        @transplant_patient ||= Renalware::Transplants::PatientPresenter.new(__getobj__)
      end

      def hd_patient
        @hd_patient ||= Renalware::HD::PatientPresenter.new(self)
      end
    end
  end
end
