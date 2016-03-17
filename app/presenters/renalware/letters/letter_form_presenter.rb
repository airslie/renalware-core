require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterFormPresenter < DumbDelegator
      def recipient_sources
        [].tap do |collection|
          collection << doctor_source if patient.doctor.present?
          collection << patient_source
          collection << manual_address_source
        end
      end

      def patient
        PatientPresenter.new(super)
      end

      def doctor
        DoctorPresenter.new(patient.doctor)
      end

      private

      def doctor_source
        label = "Doctor <address>#{doctor.full_name}, #{doctor.address_line}</address>".html_safe
        [label, "Renalware::Doctor"]
      end

      def patient_source
        label = "Patient <address>#{patient.full_name}, #{patient.address_line}</address>".html_safe
        [label, "Renalware::Patient"]
      end

      def manual_address_source
        ["Postal Address Below", ""]
      end
    end
  end
end
