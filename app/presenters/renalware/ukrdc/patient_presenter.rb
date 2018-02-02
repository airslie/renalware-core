require_dependency "renalware"

module Renalware
  module UKRDC
    class PatientPresenter < SimpleDelegator
      delegate :allergies, to: :clinical_patient
      delegate :clinic_visits, to: :clinics_patient
      delegate :profile, to: :renal_patient, allow_nil: true
      delegate :first_seen_on, to: :profile, allow_nil: true
      alias_attribute :home_telephone, :telephone1
      alias_attribute :mobile_telephone, :telephone2

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
          letters_patient.letters.approved,
          Renalware::Letters::LetterPresenterFactory
        )
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

      def observation_requests
        pathology_patient
          .observation_requests
          .having_observations_with_a_loinc_code
          .where(patient_id: id)
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
    end
  end
end
