require_dependency "renalware/letters"

module Renalware
  module Letters
    class AssignAutomaticCCs
      attr_reader :letter

      def self.build
        self.new
      end

      def call(letter)
        @letter = letter

        keep_outsiders_only
        add_patient_as_cc if !sent_to_patient?
        add_doctor_as_cc if !sent_to_doctor?
      end

      private

      def keep_outsiders_only
        letter.cc_recipients = letter.outsider_cc_recipients
      end

      def sent_to_doctor?
        letter.main_recipient.doctor?
      end

      def sent_to_patient?
        letter.main_recipient.patient?
      end

      def patient_wants_to_always_be_ccd?
        letter.patient.cc_on_letter?(letter)
      end

      def add_patient_as_cc
        add_cc_for_role("patient") if patient.cc_on_letter?(letter)
      end

      def add_doctor_as_cc
        add_cc_for_role("doctor")
      end

      def add_cc_for_role(role)
        letter.cc_recipients.create!(person_role: role)
      end

      def patient
        letter.patient
      end
    end
  end
end
