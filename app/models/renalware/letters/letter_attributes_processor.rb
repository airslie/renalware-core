require_dependency "renalware/letters"

# This class is responsible for transforming the attributes
# of a letter.  The resulting attributes can then
# be mass assigned to an ActiveRecord letter object.
module Renalware
  module Letters
    class LetterAttributesProcessor
      def initialize(patient, attributes)
        @patient = patient
        @attributes = attributes
      end

      def call
        process_main_recipient_attributes

        @attributes
      end

      private

      def process_main_recipient_attributes
        return unless @attributes.has_key?(:main_recipient_attributes)

        @attributes.merge(
          main_recipient_attributes: main_recipient_attributes
        )
      end

      def main_recipient_attributes
        RecipientAttributesProcessor.new(@patient, @attributes[:main_recipient_attributes]).call
      end
    end
  end
end