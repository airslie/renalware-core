require_dependency "renalware/hd"

module Renalware
  module Letters
    class LetterFactory
      attr_reader :patient

      def initialize(patient)
        @patient = patient
      end

      def build
        patient.letters.new.tap do |letter|
          letter.build_main_recipient(source_type: Doctor.name) if letter.main_recipient.blank?
        end
      end
    end
  end
end
