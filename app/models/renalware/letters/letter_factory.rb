require_dependency "renalware/hd"

module Renalware
  module Letters
    class LetterFactory
      attr_reader :patient

      def initialize(patient)
        @patient = patient
      end

      def build(params={})
        patient.letters.new(params).tap do |letter|
          if letter.main_recipient.blank?
            letter.build_main_recipient(person_role: :doctor)
          end
        end
      end
    end
  end
end
