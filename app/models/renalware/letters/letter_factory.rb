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
            letter.build_main_recipient(source_type: Renalware::Doctor.name)
          end
        end
      end
    end
  end
end
