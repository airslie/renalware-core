require_dependency "renalware/letters"

module Renalware
  module Letters
    class DraftLetter
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      def call(attributes)
        if assign_attributes(attributes)
          assign_automatic_cc_recipients
          save_letter
          refresh_dynamic_data_in_letter
        end
        letter
      end

      private

      def assign_attributes(attributes)
        letter.attributes = attributes
        letter.valid?
      end

      def assign_automatic_cc_recipients
        remove_automatic_ccs
        add_patient_as_cc
        add_doctor_as_cc
      end

      def refresh_dynamic_data_in_letter
        RefreshLetter.new(letter).call
      end

      def save_letter
        letter.save
      end

      def remove_automatic_ccs
        letter.cc_recipients = letter.cc_recipients.select { |r| r.source == nil }
      end

      def add_patient_as_cc
        return if letter.main_recipient.patient?
        add_source_as_cc(letter.patient) if letter.patient.cc_on_all_letters
      end

      def add_doctor_as_cc
        return if letter.main_recipient.doctor?
        add_source_as_cc(letter.patient.doctor)
      end

      def add_source_as_cc(source)
        recipient ||= letter.cc_recipients.build(source: source)
        recipient.name = source.full_name
      end
    end
  end
end
