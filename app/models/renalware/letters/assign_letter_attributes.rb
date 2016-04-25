require_dependency "renalware/letters"

module Renalware
  module Letters
    class AssignLetterAttributes
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      def call(attributes)
        letter.attributes = attributes
      end

      private

      def remove_automatic_ccs
        letter.cc_recipients = letter.cc_recipients.select { |r| r.source == nil }
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
        recipient ||= letter.cc_recipients.build(source: source)
        recipient.name = source.full_name
      end

      def patient
        letter.patient
      end
    end
  end
end
