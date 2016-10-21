require_dependency "renalware/hd"

module Renalware
  module Letters
    class LetterFactory
      attr_reader :patient

      def initialize(patient, params={}, assign_default_ccs: false)
        @patient = patient
        @assign_default_ccs = assign_default_ccs
        params = LetterParamsProcessor.new(@patient).call(params)
        @letter = Letter::Draft.new(params)
      end

      def build
        @letter.patient = patient
        include_primary_care_physician_as_default_main_recipient
        include_contacts_as_default_ccs if @assign_default_ccs
        @letter
      end

      def include_primary_care_physician_as_default_main_recipient
        return unless @letter.main_recipient.blank?

        @letter.build_main_recipient(person_role: :primary_care_physician)
      end

      def include_contacts_as_default_ccs
        contacts_with_default_cc_option.each do |contact|
          @letter.cc_recipients.build(
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
