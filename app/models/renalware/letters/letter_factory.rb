require_dependency "renalware/hd"

module Renalware
  module Letters
    class LetterFactory
      attr_reader :patient

      def initialize(patient)
        @patient = patient
      end

      def build(params={})
        params = LetterParamsProcessor.new(@patient).call(params)
        Letter::Draft.new(params).tap do |letter|
          letter.patient = patient
          include_primary_care_physician_as_default_main_recipient(letter)
          include_contacts_as_default_ccs(letter)
        end
      end

      def include_primary_care_physician_as_default_main_recipient(letter)
        if letter.main_recipient.blank?
          letter.build_main_recipient(person_role: :primary_care_physician)
        end
      end

      def include_contacts_as_default_ccs(letter)
        contacts_with_default_cc_option.each do |contact|
          letter.cc_recipients.build(
            person_role: "contact",
            addressee: contact
          )
        end
      end

      def contacts_with_default_cc_option
        @patient.contacts.default_ccs
      end
    end
  end
end
