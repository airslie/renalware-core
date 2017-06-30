require_dependency "renalware"

module Renalware
  module UKRDC
    class PatientPresenter < SimpleDelegator
      delegate :allergies, to: :clinical_patient
      delegate :clinic_visits, to: :clinics_patient

      def smoking_history
        @smoking_history ||= document.history&.smoking&.upcase
      end

      private

      def clinical_patient
        @clinical_patient ||= Renalware::Clinical.cast_patient(__getobj__)
      end

      def clinics_patient
        @clinic_patient ||= Renalware::Clinics.cast_patient(__getobj__)
      end
    end
  end
end
