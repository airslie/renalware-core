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

        remove_automatic_ccs
        add_patient_as_cc if !sent_to_patient?
        add_doctor_as_cc if !sent_to_doctor?
      end

      private

      def remove_automatic_ccs
        letter.cc_recipients = letter.manual_cc_recipients
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
        add_source_as_cc(letter.patient) if patient.cc_on_letter?(letter)
      end

      def add_doctor_as_cc
        add_source_as_cc(letter.patient.doctor)
      end

      def add_source_as_cc(source)
        letter.cc_recipients.create!(source: source, name: source.full_name)
      end

      def patient
        letter.patient
      end
    end
  end
end
