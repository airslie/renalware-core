require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterFormPresenter < DumbDelegator
      def main_recipient_sources
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

      def patient_cc_hint
        if patient.cc_on_all_letters
          "If not the recipient, the patient <b>will be CCd</b> on the letter.".html_safe
        else
          "If not the recipient, the patient <b>will NOT be CCd</b> on the letter.  "+
          "This can be changed in the patients profile.".html_safe
        end
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
