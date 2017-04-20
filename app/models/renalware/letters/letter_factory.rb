require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterFactory
      def initialize(patient, params = {})
        @params = LetterParamsProcessor.new(patient).call(params)
        @patient = patient
        @default_ccs = []
      end

      def build
        @letter = build_letter
        include_primary_care_physician_as_default_main_recipient
        assign_default_ccs
        build_salutation
        letter
      end

      def with_contacts_as_default_ccs
        @default_ccs = contacts_with_default_cc_option

        self
      end

      private

      attr_reader :patient, :letter, :params

      def build_letter
        # We should not have to set the STI type manually here but in some circumstances
        # the type is not getting set by rails STI mechanism automatically - hence this hack.
        # TODO: Get to the bottom of why this is happening by removing the type setting and
        # running all cucumber specs to assess the errors.
        Letter::Draft.new(params.merge!(type: Letter::Draft.name, patient: patient))
      end

      def include_primary_care_physician_as_default_main_recipient
        return unless letter.main_recipient.blank?

        letter.build_main_recipient(person_role: :primary_care_physician)
      end

      def contacts_with_default_cc_option
        patient.contacts.default_ccs
      end

      def build_salutation
        letter.salutation ||= patient.primary_care_physician&.salutation
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
