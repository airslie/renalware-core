require_dependency "renalware/letters"

module Renalware
  module Letters
    class DraftLetter
      def initialize(letter)
        @letter = letter
      end

      def call(attributes)
        assign_attributes(attributes)
        if valid?
          assign_default_cc_recipients
          save
        end
        @letter
      end

      private

      def assign_attributes(attributes)
        @letter.attributes = attributes
      end

      def assign_default_cc_recipients
        remove_automatic_ccs
        add_patient_as_cc
        add_doctor_as_cc
      end

      def valid?
        @letter.valid?
      end

      def save
        @letter.save
      end

      def remove_automatic_ccs
        @letter.cc_recipients = @letter.cc_recipients.select { |r| r.source == nil }
      end

      def add_patient_as_cc
        return unless @letter.patient.cc_on_all_letters
        return if @letter.main_recipient.source_type == "Renalware::Patient"
        add_source_as_cc(@letter.patient)
      end

      def add_doctor_as_cc
        return if @letter.main_recipient.source_type == "Renalware::Doctor"
        add_source_as_cc(@letter.patient.doctor)
      end

      def add_source_as_cc(source)
        recipient ||= @letter.cc_recipients.build(source: source)
        recipient.name = source.full_name
      end
    end
  end
end
