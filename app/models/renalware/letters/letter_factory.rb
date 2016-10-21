require_dependency "renalware/hd"

module Renalware
  module Letters
    class LetterFactory
      def initialize(patient, params={})
        params = LetterParamsProcessor.new(patient).call(params)
        @letter = Letter::Draft.new(params)
        @patient = patient
      end

      def build
        letter.patient = patient
        include_primary_care_physician_as_default_main_recipient

        letter
      end

      def with_contacts_as_default_ccs
        contacts_with_default_cc_option.each do |contact|
          letter.cc_recipients.build(person_role: "contact", addressee: contact)
        end

        self
      end

      private

      attr_reader :patient, :letter

      def include_primary_care_physician_as_default_main_recipient
        return unless letter.main_recipient.blank?

        letter.build_main_recipient(person_role: :primary_care_physician)
      end

      def contacts_with_default_cc_option
        patient.contacts.default_ccs
      end
    end
  end
end
