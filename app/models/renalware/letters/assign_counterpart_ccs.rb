require_dependency "renalware/letters"

module Renalware
  module Letters
    class AssignCounterpartCCs
      def self.build
        self.new
      end

      def call(letter)
        @letter = letter

        keep_outsiders_only
        add_patient_as_cc
        add_doctor_as_cc
      end

      private

      def keep_outsiders_only
        @letter.cc_recipients = @letter.outsider_cc_recipients
      end

      def add_patient_as_cc
        add_cc_for_role("patient") if patient.cc_on_letter?(@letter)
      end

      def add_doctor_as_cc
        add_cc_for_role("doctor") if doctor.cc_on_letter?(@letter)
      end

      def add_cc_for_role(role)
        @letter.cc_recipients.create!(person_role: role)
      end

      def patient
        @letter.patient
      end

      def doctor
        Renalware::Letters.cast_doctor(@letter.patient.doctor)
      end
    end
  end
end
