require_dependency "renalware/letters"

module Renalware
  module Letters
    class AssignAutomaticRecipients
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      def call
        remove_automatic_ccs
        add_patient_as_cc
        add_doctor_as_cc
      end

      private

      def remove_automatic_ccs
        letter.cc_recipients = letter.manual_cc_recipients
      end

      def add_patient_as_cc
        return if letter.main_recipient.patient?
        add_source_as_cc(letter.patient) if patient.cc_on_letter?(letter)
      end

      def add_doctor_as_cc
        return if letter.main_recipient.doctor?
        add_source_as_cc(letter.patient.doctor)
      end

      def add_source_as_cc(source)
        recipient = letter.cc_recipients.build(source: source)
        recipient.name = source.full_name
      end

      def patient
        letter.patient
      end
    end
  end
end
