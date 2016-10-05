require_dependency "renalware/hd"

module Renalware
  module Letters
    class LetterFactory
      attr_reader :patient

      def initialize(patient)
        @patient = patient
      end

      def build(params={})
        params = LetterAttributesProcessor.new(@patient, params).call
        Letter::Draft.new(params).tap do |letter|
          letter.patient = patient
          include_primary_care_physician_as_default_main_recipient(letter)
        end
      end

      def include_primary_care_physician_as_default_main_recipient(letter)
        if letter.main_recipient.blank?
          letter.build_main_recipient(person_role: :primary_care_physician)
        end
      end
    end
  end
end
