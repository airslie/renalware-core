require_dependency "renalware/hd"

module Renalware
  module Letters
    class LetterFactory
      def initialize(patient, params = {})
        @params = LetterParamsProcessor.new(patient).call(params)
        @patient = patient
        @default_ccs = []
      end

      def build
        @letter = Letter::Draft.new(@params)
        letter.patient = patient
        include_primary_care_physician_as_default_main_recipient
        assign_default_ccs
        letter
      end

      def with_contacts_as_default_ccs
        @default_ccs = contacts_with_default_cc_option

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

      def assign_default_ccs
        return if @default_ccs.empty?

        @default_ccs.each do |contact|
          letter.cc_recipients.build(person_role: "contact", addressee: contact)
        end
      end
    end
  end
end
