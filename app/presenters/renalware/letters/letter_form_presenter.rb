require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterFormPresenter < DumbDelegator
      def person_roles
        [].tap do |collection|
          collection << doctor_role if patient.doctor.present?
          collection << patient_role
          collection << other_role
        end
      end

      def patient
        PatientPresenter.new(super)
      end

      def doctor
        DoctorPresenter.new(patient.doctor)
      end

      def patient_cc_hint
        scope = "renalware.letters.hints.cc_hint"
        if patient.cc_on_all_letters
          ::I18n.t("cc_on_all_letters", scope: scope).html_safe
        else
          ::I18n.t("not_cc_on_all_letters", scope: scope).html_safe
        end
      end

      private

      def doctor_role
        label = "Doctor <address>#{doctor.full_name}, #{doctor.address_line}</address>".html_safe
        [label, "doctor"]
      end

      def patient_role
        label = "Patient <address>#{patient.full_name}, #{patient.address_line}</address>".html_safe
        [label, "patient"]
      end

      def other_role
        ["Postal Address Below", "other"]
      end
    end
  end
end
